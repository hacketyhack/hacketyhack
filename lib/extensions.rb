# Extensions to existing classes



#
# = Kernel =
#
# Additional Kernel methods.
#
module Kernel
  alias :puts :debug
end


#
# = Object =
#
# enhancements to the Object class
#
class Object
  # rails like blank?
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
  def to_a
    self.split "\n"
  end

	#used to convert strings into slugs, just like the website uses.
	def to_slug
		self.gsub(/\W/, "").gsub(/\s/, "_").downcase
	end
end


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



#
# = Time =
#
# Enhancements to the clock.
#
class Time
  def calendar
    "#{strftime('%B')} #{day.ordinalize}, #{year}"
  end
  def calendar_with_time
    "#{strftime('%B')} #{day.ordinalize}, #{year} at #{time_only}"
  end
  def time_only
    h = hour % 12
    h = 12 if h.zero?
    "#{h}:#{strftime('%M %p')}"
  end
  def quick
    "#{strftime('%b')} #{day}, #{year} at #{time_only.downcase.gsub(' ', '')}"
  end
  def short
    "#{strftime('%b')} #{day}"
  end
  def full
    strftime("%Y-%m-%d %H:%M:%S")
  end
  def since(new_time = Time.now, include_seconds = false)
    time_span = new_time.to_i - self.to_i
    distance_in_minutes = (((time_span).abs)/60).round
    distance_in_seconds = ((time_span).abs).round

    case distance_in_minutes
      when 0..1
      return (distance_in_minutes==0) ? 'less than a minute' : '1 minute' unless include_seconds
      case distance_in_seconds
        when 0..5   then 'less than 5 seconds'
        when 6..10  then 'less than 10 seconds'
        when 11..20 then 'less than 20 seconds'
        when 21..40 then 'half a minute'
        when 41..59 then 'less than a minute'
        else       '1 minute'
      end

      when 2..45    then "#{distance_in_minutes} minutes"
      when 46..90   then 'about 1 hour'
      when 90..1440   then "about #{(distance_in_minutes.to_f / 60.0).round} hours"
      when 1441..2880 then '1 day'
      else
        days = (distance_in_minutes / 1440).round
        if (days / 365) > 0
          "#{days / 365} years"
        else
        "#{days % 365} days"
        end
    end
  end
end

