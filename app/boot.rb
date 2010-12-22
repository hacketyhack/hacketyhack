# requires and initializations needed for /h-ety-h.rb
# more initializations are in h-ety-h/init.rb

require 'hpricot'

module ::HH end

def HH.anonymous_binding
  bind = ::TOPLEVEL_BINDING
  obj = eval("self", bind)
  obj.instance_variable_set("@binding", bind)
  bind
end

require 'lib/all'
require 'app/syntax/markup'

require 'app/db/sequel'

require 'app/ui/lessons'
require 'app/ui/widgets'
require 'app/ui/completion'
require 'app/ui/tabs/sidetabs'

#let's give them a simple program to start off with!
if HH::PREFS['first_run'].nil?
  File.open(File.join(HH::USER, "Hello World.rb"), "w") do |f|
    f << 'alert "Hello, world!"'
  end 

  #the first_run pref will get set by the tour notice in app/ui/mainwindow
end
