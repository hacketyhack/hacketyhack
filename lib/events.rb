class HH::EventConnection
  attr_reader :event
  def initialize event, args_cond, blk
    @event, @args_cond, @blk = event, args_cond, blk
  end

  # executes the connection if the arguments match
  def try args
    #puts args.inspect + "\n" + @args_cond.inspect
    # match size
    return if @args_cond.size != args.size

    # match content
    (0...args.size).each do |i|
      cond = @args_cond[i]
      return unless cond == :any || cond === args[i]
    end

    # the argument conditions matched
    @blk.call *args
  end

  def observer
    @blk.binding.eval("self")
  end

  def to_s
    "#<EventConnection :#{@event} #{@args_cond.inspect}] >"
  end

  alias inspect to_s
end


require 'set'

module HH::Observable
  def emit event, *args
    connections = @event_connections[event]
    connections.each {|c| c.try(args)}
  end

  # :any is a condition that always matches
  # returns the new connection (that can be useful later to delete it)
  def on_event event, *args_cond, &blk
    # in first call initialize @event_connections
    @event_connections = Hash.new(Set.new) if @event_connections.nil?
    new_conn = HH::EventConnection.new(event, args_cond, blk)
    @event_connections[event] += [new_conn]
    debug "#{new_conn} added"
    #emit :new_event_connection, new_conn
    new_conn
  end

  def delete_event_connection c
    debug "#{c} deleted!"
    @event_connections[c.event].delete c
  end
end

