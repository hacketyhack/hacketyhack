
#
# = Kernel =
#
# Additional Kernel methods.
#
module Kernel
  def say msg
    Shoes.APPS.each do |app|
      if app.respond_to? :say
        app.say msg
      end
    end
  end
end

