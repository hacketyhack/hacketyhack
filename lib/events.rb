module HH; end

class HH::EventConnection
#  module Array
#    def ===(other)
#      return false unless other.is_a? ::Array
#      (0...size).each do |i|
#        cond = self[i]
#        return false unless cond == :any || cond === other[i]
#      end
#      return false
#    end
#  end

  attr_reader :event
  
  def initialize event, args_cond, &blk
    @event, @args_cond, @blk = event, args_cond, blk
  end

  # executes the connection if the arguments match
  def try args
    # the argument conditions matched
    @blk.call *args if match? args
  end

private
  # checks if the arguments +args+ match the conditions +@args_cond+
  def match? args
    # match size
    return false if @args_cond.size != args.size

    if @args_cond.size == 1 && @args_cond[0].is_a?(Hash)
      return self.class.match_hash?(@args_cond[0], args[0])
    end

    # else match each element
    (0...args.size).each do |i|
      cond = @args_cond[i]
      return false unless cond == :any || cond === args[i]
    end
    return true
  end

  def self.match_hash?(cond, hash)
    cond.is_a?(Hash) or raise ArgumentError
    return false unless hash.is_a?(Hash)
    cond.each do |key, cond|
      return false unless cond === hash[key]
    end
    return true
  end

#  def observer
#    @blk.binding.eval("self")
#  end

public
  def to_s
    "#<EventConnection :#{@event} #{@args_cond.inspect}] >"
  end

  alias inspect to_s
end


class HH::EventCondition
  def initialize &blk
    @blk = blk
  end

  def === args
    if not args.is_a? Hash
      raise ArgumentError, "for now EventCondition only works on hash events"
    end
    @blk.call args# && match_hash?(args, {})
  end

#private
#  def simple_condition_match? args
#    HH::EventConnection.match_hash?(@simple_condition, hash)
#  end
end


require 'set'

module HH::Observable
  def emit event, *args
    return unless @event_connections
    connections = @event_connections[event]
    connections.each {|c| c.try(args)}
  end

  # :any is a condition that always matches
  # returns the new connection (that can be useful later to delete it)
  def on_event event, *args_cond, &blk
    # in first call initialize @event_connections
    @event_connections = Hash.new(Set.new) if @event_connections.nil?
    new_conn = HH::EventConnection.new event, args_cond, &blk
    @event_connections[event] += [new_conn]
    #debug "#{new_conn} added"
    #emit :new_event_connection, new_conn
    new_conn
  end

  def delete_event_connection c
    #debug "#{c} deleted!"
    @event_connections[c.event].delete c
  end
end

