# allow to track standard output
require 'lib/events'

STDOUT.extend HH::Observable

def STDOUT.write str
  emit :output, str if str
  super # default behaviour
end
