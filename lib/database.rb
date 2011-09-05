require 'sqlite3'

module HH
  class Database
    def initialize(database=nil)
      @database = database || SQLite3::Database.new(File.join(HH::USER, "db.sqlite3"))
    end

    def save(table, data)
      sql = %Q{CREATE TABLE IF NOT EXISTS #{table} (key text, value text)}
      @database.execute(sql)

      data.each do |key, value|
        sql = %Q{INSERT OR REPLACE INTO '#{table}' (key,value) VALUES ('?', '?');}
        @database.execute(sql, key.to_s, value.to_s)
      end
    end

    def load(table)
      sql = %Q{CREATE TABLE IF NOT EXISTS #{table} (key text, value text)}
      @database.execute(sql)

      rows = @database.execute( "select * from ?", table.to_s)

      {}.tap do |result|
        rows.each do |row|
          result[row["key"].to_sym] = row["value"]
        end
      end
    end
  end
end
