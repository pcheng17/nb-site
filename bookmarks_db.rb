require 'sqlite3'
require 'json'
require 'date'

class BookmarksDB
  DB_PATH = './db/bookmarks.db'

  def initialize
    @db = SQLite3::Database.new(DB_PATH)
    @db.results_as_hash = true
    setup_database
  end

  def setup_database
    # Create the bookmarks table
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
      );
    SQL

    # Create the tags table
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      );
    SQL

    # Create the bookmark_tags join table
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS bookmark_tags (
        bookmark_id INTEGER,
        tag_id INTEGER,
        PRIMARY KEY (bookmark_id, tag_id),
        FOREIGN KEY (bookmark_id) REFERENCES bookmarks(id),
        FOREIGN KEY (tag_id) REFERENCES tags(id)
      );
    SQL
  end

  def migrate_json_data(json_file_path)
    # Read JSON data
    json_data = File.read(json_file_path)
    entries = JSON.parse(json_data).reverse # Reverse to insert in chronological order

    # Begin transaction for better performance
    @db.transaction do
      entries.each do |entry|
        # Convert date string to datetime format
        created_at = DateTime.parse(entry['date']).strftime('%Y-%m-%d %H:%M:%S')

        # Insert bookmark
        @db.execute(
          "INSERT INTO bookmarks (url, title, description, created_at) VALUES (?, ?, ?, ?)",
          [entry['url'], entry['title'], entry['description'], created_at]
        )
        bookmark_id = @db.last_insert_row_id

        # Process tags
        entry['tags'].each do |tag_name|
          tag = tag_name.strip.downcase.gsub(/\s+/, '')
          # Insert tag if it doesn't exist
          @db.execute("INSERT OR IGNORE INTO tags (name) VALUES (?)", [tag])

          # Get tag_id
          tag_id = @db.get_first_value("SELECT id FROM tags WHERE name = ?", [tag])

          # Create bookmark-tag association
          @db.execute(
            "INSERT INTO bookmark_tags (bookmark_id, tag_id) VALUES (?, ?)",
            [bookmark_id, tag_id]
          )
        end
      end
    end
  end

  def get_all_bookmarks
    bookmarks = @db.execute(<<-SQL)
      SELECT
        b.*,
        GROUP_CONCAT(t.name) as tags
      FROM bookmarks b
      LEFT JOIN bookmark_tags bt ON b.id = bt.bookmark_id
      LEFT JOIN tags t ON bt.tag_id = t.id
      GROUP BY b.id
      ORDER BY b.created_at DESC
    SQL

    bookmarks.map do |bookmark|
      bookmark['tags'] = bookmark['tags']&.split(',') || []
      bookmark
    end
  end

  def get_bookmarks_by_tag(tag_name)
    @db.execute(<<-SQL, [tag_name])
      SELECT
        b.*,
        GROUP_CONCAT(t.name) as tags
      FROM bookmarks b
      JOIN bookmark_tags bt ON b.id = bt.bookmark_id
      JOIN tags t ON bt.tag_id = t.id
      WHERE EXISTS (
        SELECT 1
        FROM bookmark_tags bt2
        JOIN tags t2 ON bt2.tag_id = t2.id
        WHERE bt2.bookmark_id = b.id
        AND t2.name = ?
      )
      GROUP BY b.id
      ORDER BY b.created_at DESC
    SQL
  end
end

# Example usage:
# Initialize database and migrate data
def setup_bookmarks_db
  db = BookmarksDB.new

  # Only migrate if the bookmarks table is empty
  count = db.instance_variable_get(:@db)
           .get_first_value("SELECT COUNT(*) FROM bookmarks")

  if count == 0
    db.migrate_json_data('./data/bookmarks.json')
    puts "Data migration completed successfully!"
  end

  db
end

