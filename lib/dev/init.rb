# sets constant in the HH module and environment variables
# the current directory in set to HH::USER (~/.hacketyhack on unix systems)
# (HH::APP is initialized in h-ety-h.rb instead)

HH::NET = "hackety-hack.com"
HH::REST = "http://hackety-hack.com"
#for easy switching when developing
#HH::NET = "localhost:3000"
#HH::REST = "http://localhost:3000"
HH::HOME = Dir.pwd
HH::STATIC = HH::HOME + "/static"
HH::FONTS = HH::HOME + "/fonts"
HH::LESSONS = HH::HOME + "/lessons"
$LOAD_PATH << HH::HOME

# platform-specific directories
case RUBY_PLATFORM when /win32/, /i386-mingw32/
  require 'lib/dev/win32'
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

Dir.chdir(HH::USER)

font "#{HH::FONTS}/Lacuna.ttf"
font "#{HH::FONTS}/LiberationMono-Regular.ttf"
font "#{HH::FONTS}/LiberationMono-Bold.ttf"
font "#{HH::FONTS}/Pixelpoiiz.ttf"
font "#{HH::FONTS}/Phonetica.ttf"
font "#{HH::FONTS}/TakaoGothic.otf"
