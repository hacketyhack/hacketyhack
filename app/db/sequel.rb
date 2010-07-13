require 'app/db/core_ext'
require 'app/db/database'
require 'app/db/connection_pool'
require 'app/db/schema'
require 'app/db/dataset'
require 'app/db/model'
require 'app/db/sqlite'
require 'app/db/http'

module HH::Sequel #:nodoc:
  def self.connect(url)
    Database.connect(url)
  end
end

require 'app/db/table'

# some constant initialization
HH::DB = HH::Sequel::SQLite::Database.new(:database => File.join(HH::USER, "+TABLES"))
HH::DB.extend HH::DbMixin
HH::DB.init