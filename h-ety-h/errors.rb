#
# = Exceptions and Errors =
#
# attempting to bring friendlier
# language to the whole thing.
#
class Exception
  TRACE_RE = %r!(.+?):(.+?):in `(.+?)':\s*(.*)!
  EXCLAMATIONS = ['Oops!', 'Holy cats!', 'By jove,', 'Pardon:',
    'Whoops!', 'Great coats!', 'Hot pickles!', 'Hot snacks!',
    'Actually:', 'Crikey,', 'Yipes,']
  def file
    message[TRACE_RE, 1]
  end
  def line
    message[TRACE_RE, 2].to_i
  end
  def where
    message[TRACE_RE, 3]
  end
  def says
    message[TRACE_RE, 4] or message
  end
  def exclamation
    EXCLAMATIONS[rand(EXCLAMATIONS.length)]
  end
  def token_name t
    case t.downcase
    when "'['"
      "an opening bracket `[`"
    when "']'"
      "a closing bracket `]`"
    when "'('"
      "an opening parentheses `(`"
    when "')'"
      "a closing parentheses `)`"
    when "'{'"
      "an opening curly brace `{`"
    when "'}'"
      "a closing curly brace `}`"
    when /'(.+?)'/
      "a `#$1`"
    when "tstar"
      "an asterisk"
    when /\$end/
      "the end of the program"
    when /t(.+)/
      word = $1
      if word =~ /^[aeiou]/
        "an #{word}"
      else
        "a #{word}"
      end
    when /k(.+)/
      word = $1
      if word =~ /^[aeiou]/
        "an `#{word}`"
      else
        "a `#{word}`"
      end
    else
      t
    end
  end
  def friendly
    s = self.says
    msg, xtra = 
      case self
      when LocalJumpError
        case s
        when "no block given"
          ["A block is missing."]
        else [s]
        end
      when NoMethodError
        case s
        when /undefined method `([^']+)' for (.+?):(.+)/
          ["No `#$1` method found.", "You tried to use the `#$1` method on a #$3 object. (The object was: #{$2})"]
        when /private method `(.+?)' called for (.+?):(.+)/
          ["The `#$1` method is private on #$3.", "Check the help page for #$3 objects."]
        else [s]
        end
      when NameError
        case s
        when /uninitialized constant (.+)/
          "There is nothing called `#$1`."
        when /undefined local variable or method `(.+?)'/
          "There is nothing called `#$1`."
        else [s]
        end
      when ArgumentError
        case s
        when /wrong number of arguments \((\d+) for (\d+)\)/
          given, needed = $1.to_i, $2.to_i
          if given < needed
            ["The `#{where}` method needs a bit more.", "You sent it #{given} arguments, while it needs #{needed}."]
          else
            ["The `#{where}` method was given too much.", "You gave it #{given} arguments, but it only needs #{needed}."]
          end
        else [s]
        end
      when SyntaxError
        case s
        when /unterminated string meets end of file/
          ['You are missing an end quote.']
        when /unexpected (.+?), expecting (.+)/
          t1, t2 = $1, $2
          ["#{token_name(t2).capitalize} went missing.", "#{token_name(t1).capitalize} was found where #{token_name(t2)} should be."]
        when /unexpected (.+)/
          if $1 == "\$end"
            ["This program isn't finished.  A block or method was left open."]
          else
            ["#{token_name($1).capitalize} doesn't match up."]
          end
        else [s]
        end
      when SocketError
        case s
        when /no address associated with hostname/
          ['No such hostname (in `#{where}`.)', 'Is your internet connection okay?  Check with a browser.']
        else [s]
        end
      else
        [self.class.name, self.says]
      end
    msg = "= #{exclamation} #{msg} ="
    msg += "\n#{xtra}" if xtra
    msg
  rescue => e
    "#{e.class}: #{e.says}"
  end
  EVAL_TRACE_RE = /^\(eval\):(\d+)/
  METH_TRACE_RE = /in `([^']+)'/
  def hint
    line =
      if l = message[TRACE_RE, 2]
        l.to_i
      elsif backtrace.first
        if backtrace.first =~ /in `eval'|^\(eval\):/
          if eval_line = backtrace.grep(EVAL_TRACE_RE).first
            eval_line[EVAL_TRACE_RE, 1].to_i
          end
        end
      end
    if line
      "Check line #{line} of your program."
    elsif line = backtrace.grep(EVAL_TRACE_RE).first
      line = line[EVAL_TRACE_RE, 1]
      meth = backtrace.grep(METH_TRACE_RE).last[METH_TRACE_RE, 1]
      "The problem appears to be inside the '''#{meth}''' method used on '''line #{line}''' of your program.\n\nThis problem could be Hackety Hack's fault.  It'd be good to ask about this problem in the online [[http://talkety.hacketyhack.net forums]]."
    end
  end
end
