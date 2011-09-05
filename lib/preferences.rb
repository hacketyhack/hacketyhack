require_relative 'database'

module HH
  class Preferences
    def initialize
      begin
        @target = Database.new.load("preferences")
      rescue
        @target = {}
      end
    end

    def method_missing(meth, *args, &blk)
      @target.send(meth, *args, &blk)
    end

    def save
      Database.new.save("preferences", @target)
    end
  end
end

