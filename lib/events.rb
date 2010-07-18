class HH::EventConnection
  attr_reader :event
  def initialize event, args_cond, blk
    @event, @args_cond, @blk = event, args_cond, blk
  end

  # executes the connection if the arguments match
  def try args
    # match size
    return if @args_cond.size != args.size

    # match content
    (0...args.size).each do |i|
      return unless @args_cond[i] === args.size[i]
    end

    # the argument conditions matched
    @blk.call
  end
end


require 'set'

module HH::Observable
  @connections = Hash.new(Set.new)

  def emit event, *args
    connections = @connections[event]
    connections.each {|c| c.try(args)}
  end

  def on_event event, *args_cond, &blk
    @connections[event] += [EventConnection.new(event, args_cond, blk)]
  end

  def delete_connection c
    @connections[c.event].delete c
  end
end

