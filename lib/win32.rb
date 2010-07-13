require 'Win32API'
require 'win32/registry'

module HH
  SHGetFolderPath = Win32API.new "shell32.dll", "SHGetFolderPath", %w[P I P I P], "I"
  class << self
    def read_shell_folder(name)
      x =
        case name
        when "Personal"; 0x05
        when "AppData";  0x1A
        when "Desktop";  0x00
        end
      path = " " * 256
      SHGetFolderPath.call(0, x, 0, 0, path)
      path.strip.gsub("\0", "").gsub(/\\/, '/')
    end
    def win_vars(str)
      str.gsub(/%DESKTOP%/, ENV['DESKTOP']).
        gsub(/%USERNAME%/) { HH::PREFS['hh_username'] }.
        gsub(/%APPDATA%/, ENV['APPDATA']).
        gsub(/%MYDOCUMENTS%/, ENV['MYDOCUMENTS']).
        gsub(/%HACKETY_USER%/) { HH::USER }
    end
    def win_path(str)
      win_vars(str.gsub(/\\/, '/'))
    end
  end
end
