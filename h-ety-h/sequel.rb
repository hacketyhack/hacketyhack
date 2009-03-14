require 'h-ety-h/sequel/core_ext'
require 'h-ety-h/sequel/database'
require 'h-ety-h/sequel/connection_pool'
require 'h-ety-h/sequel/schema'
require 'h-ety-h/sequel/dataset'
require 'h-ety-h/sequel/model'
require 'h-ety-h/sequel/sqlite'
require 'h-ety-h/sequel/http'

module HH::Sequel #:nodoc:
  def self.connect(url)
    Database.connect(url)
  end
end
