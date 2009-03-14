require 'h-ety-h/yaml'

def Hacker name
  Hacker.new name
end

class Hacker
  include HH::YAML

  attr :name

  def initialize(who)
    @name = who
  end
  def inspect
    "(Hacker #{@name.inspect})"
  end
  def channel(title)
    Channel.new(@name, title)
  end
  def get_inbox_count &blk
    http('GET', '/inbox/count', :who => @name, &blk)
  end
  def get_inbox &blk
    http('GET', '/inbox', :who => @name, &blk)
  end
  def get_from_inbox msg
    http('GET', "/inbox/#{msg['id']}", :viewed => 1, :who => @name) do |msg|
      if msg['content'] =~ /^--- (.+?)\.rb\n/
        msg['script_name'] = $1
        msg['script_code'] = $'
        msg['content'] = $`
      end
      yield msg
    end
  end
  def put_in_outbox msg, &blk
    http('POST', '/outbox', msg, &blk)
  end
end
