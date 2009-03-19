require 'irb/ruby-lex'
require 'stringio'
require 'h-ety-h/markup'

module HH::Lessons
  attr_accessor :lesson, :started, :bookmark
  TITLES = {:size => 16, :font => "Lacuna Regular",
    :stroke => "#703", :margin => 4}
  PARAS = {:stroke => "#443", :size => 11, :margin_bottom => 6}
  LIST = {:margin_left => 20, :margin => 4, :size => 10}
  S = " " * 10
  POEM = "My toast has flown from my hand\n" +
         "And my toast has gone to the moon.\n" + 
         "But when I saw it on television,\n" +
         "Planting our flag on Halley's comet,\n" +
         "More still did I wish to munch it.\n"

  def subtitle txt
    @lesson.app { subtitle txt, TITLES }
  end
  def item *txt
    @lesson.app { txt << LIST; para(*txt) }
  end
  def para *txt
    @lesson.app { txt << PARAS; para(*txt) }
  end
  def link *a; @lesson.link *a end
  def em txt; @lesson.em txt end
  def strong txt; @lesson.strong txt end
  def code txt; @lesson.code txt, :stroke => "#000", :fill => "#FF6" end
  def prompt txt; @lesson.code txt, :stroke => "#EEE", :fill => "#703" end

  def check code, answer, output
    return unless @match
    return if @match[0] and code !~ @match[0]
    return if @match[2] and output !~ @match[2]
    case answer when @match[1]
      unless help(@bookmark[0], @bookmark[1] + 1)
        help(@bookmark[0] + 1, 0)
      end
    end
  end

  def help chap = 1, page = 0
    book = case chap
    when 1
      case page
      when 0
        @lesson.clear do
          subtitle "Okay, Let's Do This"
          para "The purplish-red window above is a Ruby prompt. Type a little bit of code, press ",
            em("Enter"), " and watch it go. Nothing to it."
          para "For example, try typing some math. Like: ",
            prompt("2 + 6")
        end
        @match = [/\+|\-|\/|\*/, Fixnum]
        @bookmark = [1, 0]
        raise HH::IRB::Clear
      when 1
        @lesson.clear do
          subtitle "Numbers & Math"
          para "Good! You did a bit of math. See how the answer popped out?"
          para "Ruby recognizes numbers and mathematic symbols.  You could try some other math like:"
          para "\t", code("4 * 10"), S, code("5 - 12"), S, code("40 / 4")
          para "Sure, computers are handy and fast for math.  Big deal. ",
             "Want to see your name reversed? ",
             "Type your first name in quotes like this: ", prompt('"Jimmy"')
        end
        @match = [nil, String]
      when 2
        @lesson.clear do
          subtitle "Say Your Name Backwards"
          para "Perfect, you've formed a ", strong("string"), " from the letters of your name. ",
            "A string is a set of characters the computer can process. ",
            "Imagine the letters are on a string of laundry line and the ",
            "quotes are clothespins holding the ends.  The quotes mark the ",
            "beginning and end."
          para "To reverse your name, type: ", prompt('"Jimmy".reverse'),
            " (", em("Don't forget the dot!"), ")"
        end
        @match = [/reverse/, String]
      when 3
        @lesson.clear do
          subtitle "Counting the Letters"
          para "You have used the ", code("reverse"), " ", strong("method"),
            " on your name!  By enclosing your name in quotes, you made a string. ",
            "Then you called the ", code("reverse"), " method, which works on ",
            "strings to flip all the letters backwards."
          para "Now, let's see how many letters are in your name: ",
            prompt('"Jimmy".length')
          @match = [/length/, Fixnum]
        end
      when 4
        @lesson.clear do
          subtitle "On Repeat"
          para "Now, I'm sure by now you're wondering what any of this is good for. ",
            "Well, I'm sure you've been to a website that screamed, ",
            em("Hey, your password is too short!"), " See, some programs ",
            "use this simple code."
          para "Watch this.  Let's multiply your name by 5. ",
            prompt('"Jimmy" * 5')
          @match = [/\*/, String]
        end
      end
    when 2
      case page
      when 0
        @lesson.clear do
          subtitle "Hey, Chapter No. 2 Already"
          para "Let's look at what you've learned in the first minute."
          item strong("The prompt."), " Typing code into the green prompt gives you ",
            "an answer from a red prompt.  All code gives an answer."
          item strong("Numbers and strings"), " are Ruby's math and text objects."
          item strong("Methods."), " Readable English methods like ",
            code("reverse"), " and symbolic methods like ", code("*"),
            " (to multiply.) Methods are action!"
          para "This is the essence of your learning. Taking simple things, toying with ",
            "them and turning them into new things. Doing okay? Sure you are."
          para "Okay, here's something uncomfortable.  Try reversing a number: ",
            prompt("40.reverse")
          @match = [/reverse/, nil, /`reverse` method/]
        end
      when 1
        @lesson.clear do
          subtitle "Stop, You're Barking Mad!"
          para "You can't reverse the number forty.  I guess you can hold your monitor ",
            "up to the mirror, but think about it: reversing a number just doesn't make ",
            "sense."
          para "So, Ruby has tossed an error message. It says there is no ",
            "method ", code("reverse"), " for numbers. It's true, there really isn't."
          para "Maybe if you turn it into a string: ", prompt("40.to_s.reverse")
        end
        @match = [/reverse/, /^\d+$/]
      when 2
        @lesson.clear do
          subtitle "A Horse Is Not a Cigar"
          para "And numbers are not strings.  While you can use methods on any object ",
            "in Ruby, some methods only work on certain types of things."
          para "But you can always convert between different types using Ruby's \"to\" methods."
          item strong("to_s"), " converts things to ", strong("s"), "trings."
          item strong("to_i"), " converts things to ", strong("i"), "ntegers (numbers.)"
          item strong("to_a"), " converts things to ", strong("a"), "rrays."
          para em("What are arrays?!"), " They are lists. Type in a pair of brackets: ", prompt("[]")
        end
        @match = [nil, []]
      when 3
        @lesson.clear do
          subtitle "Standing in Line"
          para "Great, that's an empty list. Lists store things ", strong("in order"), ". ",
             "Like standing in line for popcorn.  You are behind someone and you wouldn't ",
             "dream of pushing them aside, right?  And the guy behind you, you've got a ",
             "close eye on him, right?"
          para "Here's a list for you.  Lottery numbers: ", prompt("[12, 47, 35]")
        end
        @match = [nil, Array]
      when 4
        @lesson.clear do
          subtitle "One Raises Its Hand"
          para "A list of lottery numbers.  Which one is the highest?"
          para "Try: ", prompt("[12, 47, 35].max")
        end
        @match = [/max/, Fixnum]
      when 5
        @lesson.clear do
          subtitle "Tucking a List Away"
          para "Good, good.  But it's annoying to have to retype that list, isn't it?"
          para "Let's save our numbers inside a ", code("ticket"), " like so: ",
            prompt("ticket = [12, 47, 35]")
        end
        @match = [/=/, Array]
      when 6
        @lesson.clear do
          subtitle "Now Type Ticket"
          para "Now: ", prompt("ticket")
        end
        @match = [/^\S+$/, Array]
      when 7
        @lesson.clear do
          subtitle "Saved, Tucked Away"
          para "Fantastic! You've hung on to your lotto numbers, tucking them away inside a ",
            strong("variable"), " called ", code("ticket"), "."
          para "Let's put your lotto numbers in order, how about?  Use: ",
            prompt("ticket.sort!")
        end
        @match = [/sort/, Array]
      when 8
        @lesson.clear do
          subtitle "Ruby Screams If It's Permanent"
          para "You had a list.  You sorted the list.  The ", code("ticket"),
            " variable is now changed."
          para "Did you notice that the ", code("sort!"),
            " method has a big, bright exclamation at the end? ",
            "A lot of times Ruby methods shout like that if they alter the variable for good. ",
            "It's nothin special, just a mark."
          para "See for yourself: ", prompt("ticket")
        end
        @match = [/^\S+$/, Array]
      end
    when 3
      case page
      when 0
        eval("poem = #{POEM.dump}", @binding)
        @lesson.clear do
          subtitle "Chapter No. 3 is Upon Us"
          para "Now, look how your second minute went:"
          item strong("Errors."), " If you try to reverse a number or do anything fishy, ",
            "Ruby will skip the prompt and tell you so."
          item strong("Arrays"), " are lists for storing things in order."
          item strong("Variables"), " save a thing and give it a name.  You used the ",
            "equals sign to do this: ", code("ticket = [14, 37, 18]")
          para "In all there are eight lessons. You are ", code("2.0 / 8.0"), " of the way there! ",
             "This is simple stuff, don't you think? Good stuff up ahead."
          para "Let's change directions for a moment. I've stuffed a bit of poetry for you in ",
             "a certain variable. Take a look. Type ", prompt("print poem")
        end
        @match = [nil, nil, /\AMy toast /]
      when 1
        @lesson.clear do
          subtitle "Sadly, You Hate Toast Poetry"
          para "Look, it's okay. You don't have to like it. Hack it up, be my guest."
          para "Instead of toast, go for a melon or something. Try this: ",
            prompt("poem['toast'] = 'honeydew'")
          para "And then type ,", prompt("print poem"), " by itself to see the new poem."
        end
        @match = [nil, nil, /\AMy honey/]
      when 2
        @lesson.clear do
          subtitle "Ready, Aim"
          para "The square brackets you just used are very common in Ruby. ",
            "Remember, you typed: ", prompt("poem['toast'] = 'honeydew'"),
            ". That box with the word ", em("toast"), " has a square bracket ",
            " on each side, see?"
          para "The two brackets are like sights used to line up a target. ",
            'Exactly. These brackets mean, "I am looking for ____." Ready, ',
            "aim. Here you're looking for toast and swapping it out with fruit."
          para "Here's a question: what happens when we reverse this whole poem? ",
            prompt("poem.reverse")
        end
        @match = [nil, /^.ti hcnum ot /]
      when 3
        @lesson.clear do
          subtitle "Too Much Reversal"
          para "Okay, sure. So the whole poem's been turned backwards, ",
            "letter-by-letter. I really want to just reverse the lines, ",
            "though. Move the last line up to first and the first line ",
            "down to last.  Backwards, but not ", em("that"), " backwards."
          para "Here's how: ", prompt("poem.to_a.reverse")
        end
        @match = [nil, Array]
      when 4
        @lesson.clear do
          subtitle "Ringlets of Chained Methods"
          para "So what do you see? What happened there? You typed ",
            code("poem.to_a.reverse"), " and what happened?"
          para "Two things happened. You turned the ", code("poem"),
            " into a list using ", code("to_a"), ". (", strong("To a"),
            "rray.) When Ruby turns a string into an array, its breaks ",
            "the whole thing up at each line break. So you end up getting ",
            "each line of the poem."
          para "Then, you ", code("reverse"), "d that list. You had each line. ",
            "You reversed them.  That's it."
          para "Let's tack one more method on the end there: ",
            prompt("print poem.to_a.reverse.join")
        end
        @match = [nil, nil, /\AMore still did I/]
      when 5
        @lesson.clear do
          subtitle "Joining and Splitting"
          para "Good show, my friend! The ", code("join"),
            " method took that list of reversed lines and put them ",
            "together into a string. (Sure, you could have also just ",
            "used ", code("to_s"), ".)"
          para "To separate the poem into individual words, we can split it: ",
            prompt('poem.split(" ")')
        end
        @match = [nil, Array]
      end
    when 4
      case page
      when 0
        @lesson.clear do
          subtitle "Of All the Chapters, No. 4 is Here Now"
          para "Okay, hold up. Review time."
          item strong("Exclamations."), " Methods may have exclamations ",
            "(and also question marks) in their name. No big deal. Try: ",
            code('poem.include? "my hand"')
          item strong("Square brackets."), " Target and find things. Search ",
            "and replace."
          item strong("Chaining"), " methods lets you get a lot more done. ",
            "Break up a poem, reverse it, reassemble it: ",
            code("poem.to_a.reverse.join")
          para "At this point, you may want to tinker with the poem a bit more. ",
            "A complete list of all the ", code("String"), " methods is ",
            link("here", :click => "http://www.whytheluckystiff.net/ruby/pickaxe/html/ref_c_string.html"),
            ". Go ahead and try a few (such as ", code("poem.downcase"),
            " or ", code("poem.delete"), ".)"
          para "When you're ready to move on, type: ", prompt("books = {}")
        end
        @match = [nil, {}]
      when 1
        @lesson.clear do
          subtitle "A Wee Blank Book"
          para "You've made an empty ", strong("hash"), ". (Also known as: ",
            "an empty ", em("dictionary"), ".)"
          para "We're going to stuff some miniature book reviews in this hash. ",
            "Here's our rating system:"
          item code(":splendid"), " - a masterpiece."
          item code(":quite_good"), " - enjoyed, sure did."
          item code(":mediocre"), " - equal parts great and terrible."
          item code(":quite_not_good"), " - just bad in a certain way."
          item code(":abyssmal"), " - a sensitive topic."
          para "Put the title in square brackets and put ",
            "the rating after the equals."
          para "For example: ", prompt('books["Gravity\'s Rainbow"] = :splendid')
        end
        @match = [nil, Symbol]
      when 2
        @lesson.clear do
          subtitle "More Bite-Size Reviews"
          para "Keep going, fill it up with reviews. And, if you want to ",
            "see the whole list, just type: ", code("books")
          para "Ratings: ", code(":splendid"), ", ",
            code(":quite_good"), ", ", code(":mediocre"), ",\n",
            code(":quite_not_good"), ", and ", code(":abyssmal"), "."
          para "These ratings are not strings. When you place a colon ",
            "in front of a simple word, you get a ", strong("symbol"),
            ". Symbols are cheaper than strings (in terms of computer memory.) ",
            "If you use a word over and over, use a symbol. ",
            "Rather than having thousands of copies of that word in memory, ",
            "the computer will store the symbol only ", em("once"), "."
          para "Once you've got ", strong("three"), " or ", strong("four"),
            " books in  there, type: ", prompt("books.length"), "."
        end
        @match = [nil, (3..9)]
      when 3
        @lesson.clear do
          subtitle "Wait, Did I Like Gravity's Rainbow?"
          para "See, the ", code("length"), " method works on strings, ",
            "lists and hashes. One great thing about Ruby is that names ",
            "are often reused. That's fewer names you need to remember."
          para "If you'd like to look up one of your old reviews, again ",
            "put the title in the square.  But leave off the equals."
          para "Just like this: ", prompt('books["Gravity\'s Rainbow"]')
        end
        @match = [nil, Symbol]
      when 4
        @lesson.clear do
          subtitle "Hashes as Pairs"
          para "Keep in mind that hashes won't keep things in order. ",
            "That's not their job. It'll just pair up two things: a ",
            strong("key"), " and a ", strong("value"), ".  In your reviews, ",
            "the key is the book's title and the value is the rating."
          para "If you want to just see the titles of the books you've ",
            "reviewed: ", prompt("books.keys")
        end
        @match = [/keys/, Array]
      when 5
        @lesson.clear do
          subtitle "Are You Harsh?"
          para "So are you giving out harsh, unfair reviews? ",
            "Let's keep score with this hash:\n", prompt("ratings = Hash.new {0}")
          para "Then, okay, now let's count up your reviews. Just stay with me. ",
            "Type:\n", prompt("books.values.each { |rate| ratings[rate] += 1 }")
          para em("(The straight line in the code is the pipe character,\n"+
            "probably located right above the Enter key on your keyboard.)")
        end
        @match = [/\{.+\}/m, Array]
      when 6
        @lesson.clear do
          subtitle "A Tally"
          para "Great, wow! You've made a scorecard of your ratings. ",
            "Type ", code("ratings"), " to see the count. This new hash ",
            "shows a rating and then the number of times you've given that rating."
          para "One of the amazing new things we've just used is a ",
            strong("block"), ". We're going to explore these more in the ",
            "next summary. But, basically, a block is a bit of Ruby code ",
            "surrounded by curly braces."
          para "Let's try another block: ", prompt('5.times { print "Odelay!" }')
        end
        @match = [/\{.+\}/m, nil, /\AOdelay!Od/]
      end
    when 5
      case page
      when 0
        Dir.chdir(File.join(HH::HOME, 'root'))
        @lesson.clear do
          subtitle "Now Arriving at Chapter the 5th"
          para "Blocks are always attached to methods. Like the ",
            code("times"), " method, which takes the block and ",
            "runs the code over and over.  (In this case: ",
            strong("five"), " times.)"
          para "Well, that was about three minutes of learning:"
          item strong("Hashes."), " The little dictionary with the curly pages: ",
            code('{}'), "."
          item strong("Symbols."), " Tiny, efficient code words with a colon: ",
            code(":splendid"), "."
          item strong("Blocks."), " Chunks of code which can be tacked on to ",
            "many of Ruby's methods.\n",
            code("books.values.each { |rate| ratings[rate] += 1 }"), "."
          para "Now, take a give this a go: ", prompt('Dir.entries "."')
        end
        @match = [/entries/, Array]
      when 1
        @lesson.clear do
          subtitle "The Private Collection of Dr. Dir"
          para "On your computer, you probably have a lot of different files. ",
            "Files with pictures in them, files with programs in them. ",
            "And files are often organized into folders, also called: ",
            strong("directories"), "."
          para "You've just listed out everything in the current directory. ",
            "The directory this tutorial is running in, indicated by a single dot. ",
            "Containing some programs and other tutorials and such."
          para "Let's see what's in the top folder on your hard drive: ",
            prompt('Dir.entries "/"')
        end
        @match = [/entries/, Array]
      end
    when 9
      @lesson.clear do
        subtitle "At That, The Lessons Come To An Abrupt Conclusion"
        para "No further instructions are complete."
      end
      @match = nil
    end

    @bookmark = [chap, page] if book
    !!book
  end

  def time
    puts "You started #{@started.since} ago"
  end
end

class HH::IRB < RubyLex
  attr :history

  class Continue < StandardError; end
  class Empty < StandardError; end
  class Clear < StandardError; end

  def initialize lesson
    super()
    set_input(StringIO.new)
    @binding = HH.anonymous_binding
    @index = 0
    @history = []

    @main = eval("self", @binding)
    @main.extend HH::Lessons
    @main.lesson = lesson
    @main.started = Time.now
  end

  def back_history cmd
    @cmd = cmd
    if @index < @history.length
      @index += 1
      @history[@index - 1]
    end
  end

  def next_history
    if @index > 0
      @index -= 1
      if @index == 0
        @cmd
      else
        @history[@index - 1]
      end
    end
  end

  def run(str)
    obj = nil
    @io << str
    @io.rewind
    @index = 0
    unless l = lex
      raise Empty if @line == ''
    else
      l.strip!
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
      obj = eval @line, @binding, "(irb)", @line_no
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
    else
      @main.check(@line, nil, e.friendly)
      @line = ""
    end
    raise e
  ensure
    set_input(StringIO.new)
  end
end

module HH::Console
  CURSOR = ">>"
  COLORS = {
    :comment => {:stroke => "#887"},
    :keyword => {:stroke => "#FCF90F"},
    :symbol => {:stroke => "#9DF3C6"},
    :string => {:stroke => "#C9F5A5"},
    :number => {:stroke => "#C9F5A5"},
    :any => {:stroke => "#FFF"}
  }

  include HH::Markup

  def syntax(cmd)
    highlight cmd, COLORS
  end

  def console
    @str, @cmd = [CURSOR + " "], ""
    stack :margin => [50, 20, 10, 20], :width => 1.0, :height => 1.0 do
      subtitle "Try Ruby!", :font => "Lacuna Regular", :margin => 0, :size => 22
      stack :width => 1.0, :height => 0.35 do
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
          flow :margin_left => 20 do
            stack :width => 70 do
              para strong("help"),   :size => 10, :margin => 4
              para strong("help 2"), :size => 10, :margin => 4
              para strong("clear"),  :size => 10, :margin => 4
              para strong("back"),   :size => 10, :margin => 4
              para strong("reset"),  :size => 10, :margin => 4
              para strong("time"),   :size => 10, :margin => 4
            end
            stack :width => -70 do
              para "Start the 15 minute tutorial. Trust me, it's very basic!",
                :size => 10, :margin => 4
              para "Hop to chapter two.", :size => 10, :margin => 4
              para "Clear the screen. (If things start to slow down.)", :size => 10, :margin => 4
              para "Go back one page in the tutorial.", :size => 10, :margin => 4
              para "Reset the prompt. If it stops responding.", :size => 10, :margin => 4
              para "A stopwatch. How long have you been in here?", :size => 10, :margin => 4
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
          @say.show
          out, obj = @irb.run(@cmd)
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
          @str += [syntax(@cmd), "\n.. "]
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
        @cmd = @irb.next_history
      when :tab
        @cmd += "  "
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

    def say msg
      @say.text = msg
    end
  end
end
