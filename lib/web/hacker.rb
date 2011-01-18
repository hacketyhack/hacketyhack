# website integration

require 'lib/web/yaml'

def Hacker name
  Hacker.new name
end

class Hacker
  include HH::YAML

  attr :name
  attr :password
  attr :email

  def initialize(who)
    @name = who[:username]
    @password = who[:password]
    @email = who[:email]
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

  def auth_check &blk
    http('POST', "/check_credentials", {:username => @name, :password => @password}) do |result|
      blk[result.response]
    end
  end

  def sign_up! &blk
    http('POST', "/signup_via_api", {:username => @name, :email => @email, :password => @password}) do |result|
      blk[result.response]
    end
  end

  def save_program_to_the_cloud name, code, &blk
    url = "/programs/#{@name}/#{name}.json"
    http('PUT', url, {:creator_username => @name, :title => name, :code => code, :username => @name, :password => @password}) do |result|
      blk[result.response]
    end
  end

end
