#
# = String =
#
# Enhancements to strings.
#
class String
  def starts?( beginning )
    self[0, beginning.length] == beginning
  end
  def ends?( ending )
    self[-ending.length, ending.length] == ending
  end
  def remove( phrase )
    r = dup
    r[phrase] = ""
    r
  end
end
