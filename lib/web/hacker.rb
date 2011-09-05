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

# I feel like these belong in Hacker. Trying to not do too much at once
module HH
  class << self
    def scripts
      Dir["#{HH::USER}/*.rb"].map { |path| get_script(path) }.
        sort_by { |script| Time.now - script[:mtime] }
    end

    def get_script(path)
      app = {:name => File.basename(path, '.rb'), :script => File.read(path)}
      m, = *app[:script].match(/\A(([ \t]*#.+)(\r?\n|$))+/)
        app[:mtime] = File.mtime(path)
      app[:desc] = m.gsub(/^[ \t]*#+[ \t]*/, '').strip.gsub(/\n+/, ' ') if m
        app
    end
    def samples
      Dir["#{HH::HOME}/samples/*.rb"].map do |path|
        s = get_script(path)
        # set the creation time to nil
        s[:mtime] = nil
        s[:sample] = true
        s
      end.sort_by { |script| script[:name] }
    end

    def save_prefs
      HH::PREFS.save
    end

    def script_exists?(name)
      File.exists?(HH::USER + "/" + name + ".rb")
    end

    def save_script(name, code)
      APP.emit :save, :name => name, :code => code
      File.open(HH::USER + "/" + name + ".rb", "w") do |f|
        f << code
      end
      return if PREFS['username'].blank?
    end

    def get_script(path)
      app = {:name => File.basename(path, '.rb'), :script => File.read(path)}
      m, = *app[:script].match(/\A(([ \t]*#.+)(\r?\n|$))+/)
      app[:mtime] = File.mtime(path)
      app[:desc] = m.gsub(/^[ \t]*#+[ \t]*/, '').strip.gsub(/\n+/, ' ') if m
      app
    end

  end
end

