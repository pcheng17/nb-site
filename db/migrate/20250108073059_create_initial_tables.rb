class CreateInitialTables < ActiveRecord::Migration[7.2]
  def change
    create_table :bookmarks do |t|
      t.string :url, null: false
      t.string :title, null: false
      t.text :description
      t.timestamps
    end

    create_table :tags do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :taggings do |t|
      t.belongs_to :link
      t.belongs_to :tag
      t.timestamps
    end

    add_index :bookmarks, :url, unique: true
    add_index :tags, :name, unique: true
  end
end
