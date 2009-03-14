#
# = Object =
#
class Object
  def blank?
    if respond_to? :empty?
      empty?
    elsif respond_to? :zero?
      zero?
    else
      !self
    end
  end

  def tap
    yield self
    self
  end

  def try(method, *args)
    respond_to?(method) ? send(method, *args) : self
  end
end
