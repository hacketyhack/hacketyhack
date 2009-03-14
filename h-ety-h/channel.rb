require 'h-ety-h/yaml'

def Channel(name)
  Hacker('_why').channel(name)
end

class Channel
  include HH::YAML

  attr_reader :owner, :name

  def initialize(owner, name)
    @owner = owner
    @name = name
    @since = 0
    @received = {}
  end
  def inspect
    "(Channel #{@owner}'s #{@name})"
  end
  def start &blk
    http('POST', '/channels', :title => @name, :who => @owner, &blk)
    self
  end
  def hear &blk
    return if @hear
    @hear = http('GET', "/channels/#@name", :since => @since, :who => @owner) do |objs|
      begin
        objs = objs.map do |m|
          next if @received[m["id"]]
          t = m["at"].to_i
          @since = t if t > @since
          @received[m["id"]] = true
          begin
            m["said"] = YAML.load(m["object"])
            Message.new(m)
          rescue
            nil
          end
        end
        if blk
          objs.compact.
          sort_by { |x| x.at }.
          each do |x|
            blk[x]
          end
        end
      rescue
      end
      @hear = nil
    end
    self
  end
  def say obj
    http('PUT', '/channels/' + @name, :who => @owner, :post => YAML.dump(obj))
    self
  end

  class Message
    attr_reader :said, :hacker, :at, :id
    def initialize(opts = {})
      @said = opts['said']
      @hacker = Hacker(opts['hacker'])
      @at = opts['at']
      @id = opts['id']
    end
  end
end
