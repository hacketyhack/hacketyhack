require 'sqlite3'

module HH
  class Database
    def initialize(database=nil)
      @database = database || SQLite3::Database.new(File.join(HH::USER, "db.sqlite3"))
    end

    def save(table, data)
      sql = %Q{CREATE TABLE IF NOT EXISTS #{table} (key text UNIQUE, value text)}
      @database.execute(sql)

      data.each do |key, value|
        sql = %Q{INSERT OR REPLACE INTO #{table} (key,value) VALUES ("#{key}", "#{value}")}
        @database.execute(sql)
      end
    end

    def load(table)
      sql = %Q{CREATE TABLE IF NOT EXISTS #{table} (key text UNIQUE, value text)}
      @database.execute(sql)

      rows = @database.execute("SELECT * FROM #{table}")

      {}.tap do |result|
        rows.each do |row|
          result[row["key"].to_sym] = row["value"]
        end
      end
    end
  end
end
