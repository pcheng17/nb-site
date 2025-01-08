require 'active_record'
require_relative 'models/bookmark'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/bookmarks_dev.sqlite'
)
