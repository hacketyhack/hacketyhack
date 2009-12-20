require 'h-ety-h/yaml'

def Hacker name
  Hacker.new name
end

class Hacker
  include HH::YAML

  attr :name
	attr :key
	attr :password

  def initialize(who)
    @name = who['username']
		@password = who['password']
		@key = who['key']
  end

  def inspect
    "(Hacker #{@name.inspect})"
  end

  def channel(title)
    Channel.new(@name, title)
  end

  def get_inbox_count &blk
    http('GET', '/messages.yaml', :who => @name, :api_key => @key, &blk)
  end

  def get_inbox &blk
    http('GET', '/messages.yaml', :who => @name, :api_key => @key, &blk)
  end

  def get_from_inbox msg
    http('GET', "/messages/#{msg['id']}.yaml", :who => @name) do |msg|
			msg = msg['message']
      if msg['text'] =~ /^--- (.+?)\.rb\n/
        msg['script_name'] = $1
        msg['script_code'] = $'
        msg['text'] = $`
      end
      yield msg
    end
    http('GET', "/messages/#{msg['id']}/mark_read", :api_key => @key) { |b| true }
  end

  def put_in_outbox msg, &blk
		msg[:api_key] = @key
    http('POST', '/messages', msg, &blk)
  end

	def update_programs &blk
    http('GET', '/programs.yaml', :who => @name, :api_key => @key, &blk)
	end

end
