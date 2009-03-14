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
