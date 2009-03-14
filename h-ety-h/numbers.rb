#
# = Numbers =
#
# Enhancements to the basic number classes.
#
class Fixnum
  def ordinalize
    case self
    when 1;  "1st"
    when 2;  "2nd"
    when 3;  "3rd"
    else     "#{self}th"
    end
  end
  def weeks; self * 7*24*60*60; end
end
