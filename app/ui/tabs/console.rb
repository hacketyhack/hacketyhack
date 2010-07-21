# the console (try ruby) tab content
# includes to code for the try ruby lessons

require 'irb/ruby-lex'
require 'stringio'


class HH::IRB < RubyLex
  attr :history

  class Continue < StandardError; end
  class Empty < StandardError; end
  class Clear < StandardError; end

  def initialize lesson
    super()
    set_input(StringIO.new)
    @binding = ::TOPLEVEL_BINDING
    @history = []
    reset_history

    @main = eval("self", @binding)
    @main.extend HH::Lessons
    @main.lesson = lesson
    @main.started = Time.now
  end

  def back_history cmd
    if @index < @tmp_history.length-1
      @tmp_history[@index] = cmd
      @index += 1
      @tmp_history[@index]
    else
      cmd
    end
  end

  def next_history cmd
    if @index > 0
      @tmp_history[@index] = cmd
      @index -= 1
      @tmp_history[@index]
    else
      cmd
    end
  end

  def reset_history
    @index = 0
    @tmp_history = [nil] + @history
  end

  def run(str)
    obj = nil
    @io << str
    @io.rewind
    unless l = lex
      raise Empty if @line == ''
    else
      l.strip!
      l.chop! #remove the trailing ;
      @history.unshift l
      case l
      when "reset"
        @line = ""
      when "clear"
        raise Clear if @line == ''
      else
        @line << l << "\n"
        if @ltype or @continue or @indent > 0
          raise Continue
        end
      end
    end
    unless @line.empty?
      begin
        obj = eval @line, @binding, "(irb)", @line_no
      rescue Exception => e
        STDOUT << e.class << " " << (e.class == SyntaxError) << "\n"
        if e.says =~ /unexpected \$end/
          raise Continue
        else
          raise e
        end
      end
    end
    $stdout.rewind
    output = $stdout.read
    $stdout.truncate(0)
    $stdout.rewind
    @main.check(@line, obj, output)

    @indent = 0
    @indent_stack = []
    @line_no += @line.scan(/\n/).length
    @line = ''
    @exp_line_no = @line_no

    [output, obj]
  rescue Object => e
    case e when Empty, Continue
      # do nothing
    else
      @main.check(@line, nil, e.friendly)
      @line = ""
    end
    raise e
  ensure
    reset_history
    set_input(StringIO.new)
  end
end





module HH::Console
  CURSOR = ">>"
  CONTINUE = ".."
  COLORS = {
    :comment => {:stroke => "#887"},
    :keyword => {:stroke => "#FCF90F"},
    :symbol => {:stroke => "#9DF3C6"},
    :string => {:stroke => "#C9F5A5"},
    :number => {:stroke => "#C9F5A5"},
    :any => {:stroke => "#FFF"},
    :matching => {:stroke => "#f00", :weight => "bold"},
  }

  include HH::Markup

  def syntax(cmd)
    if cmd.nil?
      error "cmd is nil #{__FILE__}:#{__LINE__}"
      return []
    end
    cursor_pos = cmd.size-1
    highlight cmd, cursor_pos, COLORS
  end

  def console
    @str, @cmd = [CURSOR + " "], ""
    stack :margin => [10, 20, 10, 20], :width => 1.0, :height => 1.0 do
      subtitle "Try Ruby!", :font => "Lacuna Regular", :margin => 0, :size => 22
      stack :width => 1.0, :height => 0.50 do
        image "#{HH::STATIC}/hhconsole.png", :top => 0, :left => 0, :width => -5, :height => 1.0
        @say = para "Hi!", :align => 'center', :stroke => white, :size => 10,
          :left => 0, :top => 236, :hidden => true
        @scroll =
          stack :width => 1.0, :height => 1.0, :scroll => true, :margin => [20, 10, 20, 10] do
            para "Interactive Ruby ready.", :fill => "#FD5396", :stroke => black,
              :font => "Liberation Mono Bold", :size => 10
            @console = para @str, :font => "Liberation Mono",
              :stroke => "#CBE134", :size => 10, :wrap => "char"
            @console.cursor = -1
          end
      end

      @lesson =
        stack :margin_top => 8 do
          para "Try out Ruby code in the prompt above. Here are some commands to get you started:"
          stack :margin_left => 20 do
            flow do
              stack :width => 70 do
                para strong("clear"),  :size => 10, :margin => 4
              end
              stack :width => -70 do
                para "Clear the screen. (If things start to slow down.)", :size => 10, :margin => 4
              end
            end
            flow do
              stack :width => 70 do
                para strong("reset"),  :size => 10, :margin => 4
              end
              stack :width => -70 do
              para "Reset the prompt. If it stops responding.", :size => 10, :margin => 4
              end
            end
            flow do
              stack :width => 70 do
                para strong("time"),  :size => 10, :margin => 4
              end
              stack :width => -70 do
                para "A stopwatch. How long have you been in here?", :size => 10, :margin => 4
              end
            end
            stack :width => -70 do
            end
          end
        end
    end

    @irb = HH::IRB.new(@lesson)
    $stdout = StringIO.new

    keypress do |k|
      case k
      when "\n"
        begin
          @multiline = false
          @say.show
          out, obj = @irb.run(@cmd + ';')
          @str += [syntax(@cmd), "\n"]
          @str << span(out, :stroke => white) if out
          @str += [span("=> ", :stroke => "#fd5396"),
            syntax(obj.inspect),
            "\n#{CURSOR} "]
          @cmd = ""
        rescue HH::IRB::Clear
          @str, @cmd = [CURSOR + " "], ""
        rescue HH::IRB::Empty
          @str << "\n#{CURSOR} "
          @cmd = ""
        rescue HH::IRB::Continue
          @multiline = true
          @str += [syntax(@cmd), "\n#{CONTINUE} "]
          @cmd = ""
        rescue Object => e
          @str += [syntax(@cmd), "\n", 
            span("#{e.friendly}\n", :stroke => "#FC994F"),
            "#{CURSOR} "]
          @cmd = ""
        ensure
          @say.hide
        end
      when String
        @cmd += k
      when :backspace
        @cmd.slice!(-1)
      when :up
        @cmd = @irb.back_history @cmd
      when :down
        @cmd = @irb.next_history @cmd
      when :tab
        autocomplete
      when :alt_q
        quit
      when :alt_c
        self.clipboard = @cmd
      when :alt_v
        @cmd += self.clipboard
      end
      @console.replace *(@str + syntax(@cmd))
      @scroll.scroll_top = @scroll.scroll_max
    end
  end

  # number of autocompletion possibilieties shown
  COMPLETION_N = 15

  def autocomplete
    index = @cmd.rindex(/[^\w\.\d:]/)
    if index
      last = @cmd[index+1..-1]
    else
      last = @cmd
    end
    # special case for strings and regular expressions
    # check last character
    last_char = @cmd[-last.size-1, 1]
    if last_char == '"' or last_char == '/'
      # find first index of " or /
      i = @cmd.rindex(last_char, -last.size-2)
      # include string/regexp
      last = @cmd[i..-1] if i
    end
    #STDOUT << last << "\n"
    options = HH::InputCompletor.complete(last, @binding)
    options = options.select{|x| x}#.sort
    completion = options.first
    options.each do |o|
      while o[0, completion.size] != completion
        # remove last char
        completion[-1] = ''
      end
    end

    @cmd[-last.size..-1] = completion if completion and last.size > 0
    if options.size > 1
      # display options
      @str += [syntax(@cmd), "\n"]
      @str << options[0...COMPLETION_N].join(' ')
      size = options.size
      @str << " [#{COMPLETION_N} of #{size}]" if size > COMPLETION_N
      if @multiline
        @str << "\n#{CONTINUE} "
      else
        @str << "\n#{CURSOR} "
      end
    end
  end

  def say msg
    @say.text = msg
  end

end
