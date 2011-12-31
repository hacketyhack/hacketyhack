require 'lib/database'
require 'lib/preferences'

module HH
  PREFS = Preferences.new
end

require 'lib/web/all'
require 'lib/dev/init'
require 'lib/editor/all'

require 'lib/art/turtle'
require 'lib/enhancements'
require 'lib/dev/errors'
require 'lib/dev/events'
require 'lib/dev/stdout'

