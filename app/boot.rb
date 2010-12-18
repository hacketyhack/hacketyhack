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
require 'app/web/all'
require 'app/syntax/markup'

require 'app/db/sequel'

require 'app/ui/lessons'
require 'app/ui/widgets'
require 'app/ui/completion'
require 'app/ui/tabs/sidetabs'
