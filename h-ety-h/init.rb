#HH::NET = "hacketyhack.heroku.com"
#HH::REST = "http://hacketyhack.heroku.com"
#for easy switching when developing
HH::NET = "localhost:3000"
HH::REST = "http://localhost:3000"
HH::HOME = Dir.pwd
HH::STATIC = Dir.pwd + "/static"
HH::FONTS = HH::HOME + "/fonts"
$LOAD_PATH << HH::HOME

# platform-specific directories
case RUBY_PLATFORM when /win32/
  require 'h-ety-h/win32'
  HOME = ENV['USERPROFILE'].gsub(/\\/, '/')
  ENV['MYDOCUMENTS'] = HH.read_shell_folder('Personal')
  ENV['APPDATA'] = HH.read_shell_folder('AppData')
  ENV['DESKTOP'] = HH.read_shell_folder('Desktop')
  HH::USER = 
    begin
      HH.win_path(Win32::Registry::HKEY_CURRENT_USER.
                  open('Software\Hackety.org\Hackety Hack').
                  read_s('HackFolder'))
    rescue
      HH.win_path('%APPDATA%/Hackety Hack')
    end
else
  ENV['DESKTOP'] = File.join(ENV['HOME'], "Desktop")
  ENV['APPDATA'] = ENV['HOME']
  ENV['MYDOCUMENTS'] = ENV['HOME']
  HH::USER = File.join(ENV['HOME'], ".hacketyhack")
end

HH::DOWNLOADS = File.join(HH::USER, 'Downloads')
FileUtils.makedirs(HH::DOWNLOADS)
HH::DB = HH::Sequel::SQLite::Database.new(:database => File.join(HH::USER, "+TABLES"))
HH::DB.extend HH::DbMixin
HH::DB.init

Dir.chdir(HH::USER)
