# website integration

require 'lib/web/yaml'
require 'lib/web/api'

def Hacker name
  Hacker.new name
end

class Hacker
  include HH::YAML
  include HH::API

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
    programs_rel = HH::API.root.at("//a[@rel='/rels/program-index']")
    HH::API.http('GET', program_rel.attributes['href'], &blk)
  end

  def auth_check &blk
    progs = open(HH::API_ROOT + '/programs') { |f| Hpricot(f)}
    csrf = progs.at("//meta[@name='csrf-token']")

    HH::API.http('POST', "/users/sign_in", {:authenticity_token => csrf, :user => {:username => @name, :password => @password, :remember_me => 1}}) do |result|
      blk[result.response]
    end
  end

  def sign_up! &blk
    progs = open(HH::API_ROOT + '/programs') { |f| Hpricot(f)}
    csrf = progs.at("//meta[@name='csrf-token']")

    HH::API.http('POST', "/users", {:authenticity_token => csrf, :user =>{:username => @name, :email => @email, :password => @password, :password_conformation => @password }}) do |result|
      blk[result.response]
    end
  end

  def save_program_to_the_cloud name, code, &blk
    program_rel = HH::API.root.at("//a[@rel='/rels/program-new']")
    new_program = open(HH::API_ROOT + program_rel.attributes['href']){ |f| Hpricot(f) }
    csrf = new_program.at("//meta[@name='csrf-token']")
    form = new_program.at("//form")
    HH::API.http(form.attributes['method'], form.attributes['action'], {:authenticity_token => csrf, :program => {:author_username => @name, :title => name, :source_code => code}}) do |result|
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

