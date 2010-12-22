require 'lib/web/yaml'

module HH::Sequel
  module HTTP
    class Database < HH::Sequel::Database
      set_adapter_scheme :http
      attr_reader :url

      include HH::YAML
    
      def initialize(opts = {})
        super
      end
    
      def dataset(opts = nil)
        Dataset.new(self, opts)
      end
    
      def tables
        fetch_uri(:Get)
      end
    
      def drop_table(name)
        fetch_uri(:Delete, name)
      end
    end
    
    class Dataset < HH::Sequel::Dataset
      def each(opts = nil, &block)
        res = @db.fetch_uri(:Get, @opts[:from], opts)
        res.each(&block)
        self
      end
    
      LIMIT_1 = {:limit => 1}.freeze
    
      def first(opts = nil)
        opts = opts ? opts.merge(LIMIT_1) : LIMIT_1
        @db.fetch_uri(:Get, @opts[:from], opts).first
      end
    
      def last(opts = nil)
        raise RuntimeError, 'No order specified' unless
          @opts[:order] || (opts && opts[:order])
      
        opts = {:order => reverse_order(@opts[:order])}.
          merge(opts ? opts.merge(LIMIT_1) : LIMIT_1)
        @db.fetch_uri(:Get, @opts[:from], opts).first
      end
      
      def count(opts = nil)
        @db.fetch_uri(:Get, "#{@opts[:from]}/count", opts)
      end
    
      def insert(values = nil, opts = nil)
        @db.fetch_uri(:Post, @opts[:from], values)
      end
    
      def save(values = nil, opts = nil)
        @db.fetch_uri(:Post, @opts[:from], values)
      end
    
      def bulk_insert(values = nil, opts = nil)
        @db.fetch_uri(:Put, "#{@opts[:from]}/new", YAML.dump(values))
      end
    
      def update(values, opts = nil)
        @db.fetch_uri(:Post, @opts[:from], values)
        self
      end
    
      def delete(opts = nil)
        @db.fetch_uri(:Delete, @opts[:from])
        self
      end
    end
  end
end
