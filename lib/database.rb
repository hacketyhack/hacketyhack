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
        sql = if value.nil? || value == false
                %Q{DELETE FROM #{table} WHERE key = "#{key}"}
              else
                %Q{INSERT OR REPLACE INTO #{table} (key,value) VALUES ("#{key}", "#{value}")}
              end
        @database.execute(sql)
      end
    end

    def load(table)
      sql = %Q{CREATE TABLE IF NOT EXISTS #{table} (key text UNIQUE, value text)}
      @database.execute(sql)

      rows = @database.execute("SELECT * FROM #{table}")

      {}.tap do |result|
        rows.each do |row|
          result[row[0].to_sym] = row[1]
        end
      end
    end
  end
end
