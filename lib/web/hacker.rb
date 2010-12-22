# website integration

require 'lib/web/yaml'

def Hacker name
  Hacker.new name
end

class Hacker
  include HH::YAML

  attr :name
  attr :password

  def initialize(who)
    @name = who[:username]
    @password = who[:password]
  end

  def inspect
    "(Hacker #{@name})"
  end

  def channel(title)
    Channel.new(@name, title)
  end

  def program_list &blk
    http('GET', "/programs/#{@name}.json", :username => @name, :password => @password, &blk)
  end

  def save_program_to_the_cloud name, code
    url = "/programs/#{@name}/#{name}.json"
    http('PUT', url, {:creator_username => @name, :title => name, :code => code, :username => @name, :password => @password}) {|u| true }
  end

end
