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
  
#  def thread
#    @blk.binding.eval("Thread.current")
#  end
end


require 'set'

module HH::Observable
  def emit event, *args
    connections = @connections[event]
    connections.each {|c| c.try(args)}
  end

  # :any is a condition that always matches
  # returns the new connection (that can be useful later to delete it)
  def on_event event, *args_cond, &blk
    @connections = Hash.new(Set.new) if @connections.nil? # on first call
    new_conn = HH::EventConnection.new(event, args_cond, blk)
    @connections[event] += [new_conn]
    emit :new_event_connection, new_conn
    new_conn
  end

  def delete_event_connection c
    @connections[c.event].delete c
  end
end

