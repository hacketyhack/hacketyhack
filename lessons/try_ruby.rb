lesson_set "Try Ruby" do
  init do
    S = " " * 10
    POEM = "My toast has flown from my hand\n" +
           "And my toast has gone to the moon.\n" +
           "But when I saw it on television,\n" +
           "Planting our flag on Halley's comet,\n" +
           "More still did I wish to munch it.\n"

    # convenience method
    def next_when_command *args, &blk
      next_when :try_ruby_command, *args, &blk
    end
    
    def eval_in_console code
      HH::APP.console_binding.eval code
    end
  end
  

  lesson "Getting Started"

  page "Okay, Let's Do This" do
    para "The purplish-red window above is a Ruby prompt. Type a little bit of code, press ",
        em("Enter"), " and watch it go. Nothing to it."
    para "For example, try typing some math. Like: ",
        prompt("2 + 6")
    # just a proof of concept code TODO: remove
#    next_when_command do |event_args|
#      a, c = event_args[:answer], event_args[:code]
#      c =~ /\+|\-|\/|\*/ && a.is_a?(Fixnum) && a > 0 && a < 20 && a%2==0
#    end
    next_when_command :code => /\+|\-|\/|\*/, :answer => Numeric
  end

  page "Numbers & Math" do
    para "Good! You did a bit of math. See how the answer popped out?"
    para "Ruby recognizes numbers and mathematic symbols.  You could try some other math like:"
    para "\t", code("4 * 10"), S, code("5 - 12"), S, code("40 / 4")
    para "Sure, computers are handy and fast for math.  Big deal. ",
       "Want to see your name reversed? ",
       "Type your first name in quotes like this: ", prompt('"Jimmy"')
    next_when_command :answer => String
  end

  page "Say Your Name Backwards" do
    para "Perfect, you've formed a ", strong("string"), " from the letters of your name. ",
      "A string is a set of characters the computer can process. ",
      "Imagine the letters are on a string of laundry line and the ",
      "quotes are clothespins holding the ends.  The quotes mark the ",
      "beginning and end."
    para "To reverse your name, type: ", prompt('"Jimmy".reverse'),
      " (", em("Don't forget the dot!"), ")"
    next_when_command :code => /reverse/, :answer => /..+/
  end

  page "Counting the Letters" do
    para "You have used the ", code("reverse"), " ", strong("method"),
      " on your name!  By enclosing your name in quotes, you made a string. ",
      "Then you called the ", code("reverse"), " method, which works on ",
      "strings to flip all the letters backwards."
    para "Now, let's see how many letters are in your name: ",
    prompt('"Jimmy".length')
    next_when_command :code => /length/, :answer => Fixnum
  end

  page "On Repeat" do
    para "Now, I'm sure by now you're wondering what any of this is good for. ",
      "Well, I'm sure you've been to a website that screamed, ",
      em("Hey, your password is too short!"), " See, some programs ",
      "use this simple code."
    para "Watch this.  Let's multiply your name by 5. ",
      prompt('"Jimmy" * 5')
    next_when_command :code => /\*/, :answer => /.{5,}/
  end


  lesson "Arrays"

  page "Hey, Chapter No. 2 Already" do
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
    next_when :try_ruby_command_error,
               :code => /reverse/, :output => /`reverse` method/
  end

  page "Stop, You're Barking Mad!" do
    para "You can't reverse the number forty.  I guess you can hold your monitor ",
      "up to the mirror, but think about it: reversing a number just doesn't make ",
      "sense."
    para "So, Ruby has tossed an error message. It says there is no ",
      "method ", code("reverse"), " for numbers. It's true, there really isn't."
    para "Maybe if you turn it into a string: ", prompt("40.to_s.reverse")
    next_when_command :code => /reverse/, :answer => /^\d\d+$/
  end

  page "A Horse Is Not a Cigar" do
    para "And numbers are not strings.  While you can use methods on any object ",
      "in Ruby, some methods only work on certain types of things."
    para "But you can always convert between different types using Ruby's \"to\" methods."
    item strong("to_s"), " converts things to ", strong("s"), "trings."
    item strong("to_i"), " converts things to ", strong("i"), "ntegers (numbers.)"
    item strong("to_a"), " converts things to ", strong("a"), "rrays."
    para em("What are arrays?!"), " They are lists. Type in a pair of brackets: ", prompt("[]")
    next_when_command :answer => []
  end

  page "Standing in Line" do
    para "Great, that's an empty list. Lists store things ", strong("in order"), ". ",
      "Like standing in line for popcorn.  You are behind someone and you wouldn't ",
      "dream of pushing them aside, right?  And the guy behind you, you've got a ",
      "close eye on him, right?"
    para "Here's a list for you.  Lottery numbers: ", prompt("[12, 47, 35]")
    next_when_command :answer => Array
  end

  page "One Raises Its Hand" do
    para "A list of lottery numbers.  Which one is the highest?"
    para "Try: ", prompt("[12, 47, 35].max")
    next_when_command :code => /max/, :answer => Fixnum
  end

  page "Tucking a List Away" do
    para "Good, good.  But it's annoying to have to retype that list, isn't it?"
    para "Let's save our numbers inside a ", code("ticket"), " like so: ",
      prompt("ticket = [12, 47, 35]")
    next_when_command :code => /=/, :answer => Array
  end

  page "Now Type Ticket" do
    para "Now: ", prompt("ticket")
    next_when_command :code => /^\S+$/, :answer => Array
  end

  page "Saved, Tucked Away" do
    para "Fantastic! You've hung on to your lotto numbers, tucking them away inside a ",
      strong("variable"), " called ", code("ticket"), "."
    para "Let's put your lotto numbers in order, how about?  Use: ",
      prompt("ticket.sort!")
    next_when_command :code => /sort!/, :answer => Array
  end
  
  page "Ruby Screams If It's Permanent" do
    para "You had a list.  You sorted the list.  The ", code("ticket"),
      " variable is now changed."
    para "Did you notice that the ", code("sort!"),
      " method has a big, bright exclamation at the end? ",
      "A lot of times Ruby methods shout like that if they alter the variable for good. ",
      "It's nothin special, just a mark."
    para "See for yourself: ", prompt("ticket")
    next_when_command :code => /^\S+$/, :answer => Array
  end



  lesson "Poetry"

  page "Chapter No. 3 is Upon Us" do
    eval_in_console "poem = #{POEM.dump}"
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
    next_when_command :output => /\AMy toast /
  end

  page "Sadly, You Hate Toast Poetry" do
    para "Look, it's okay. You don't have to like it. Hack it up, be my guest."
    para "Instead of toast, go for a melon or something. Try this: ",
      prompt("poem['toast'] = 'honeydew'")
    para "And then type ,", prompt("print poem"), " by itself to see the new poem."
    next_when_command :output => /\AMy honey/
  end

  page "Ready, Aim" do
    para "The square brackets you just used are very common in Ruby. ",
      "Remember, you typed: ", code("poem['toast'] = 'honeydew'"),
      ". That box with the word ", em("toast"), " has a square bracket ",
      " on each side, see?"
    para "The two brackets are like sights used to line up a target. ",
      'Exactly. These brackets mean, "I am looking for ____." Ready, ',
      "aim. Here you're looking for toast and swapping it out with fruit."
    para "Here's a question: what happens when we reverse this whole poem? ",
      prompt("poem.reverse")
    next_when_command :answer => /^.ti hcnum ot /
  end
  
  page "Too Much Reversal" do
    para "Okay, sure. So the whole poem's been turned backwards, ",
      "letter-by-letter. I really want to just reverse the lines, ",
      "though. Move the last line up to first and the first line ",
      "down to last.  Backwards, but not ", em("that"), " backwards."
    para "Here's how: ", prompt("poem.to_a.reverse")
    next_when_command :code => /reverse/, :answer => Array
  end
  
  page "Ringlets of Chained Methods" do
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
    next_when_command :output => /\AMore still did I/
  end
  
  page "Joining and Splitting" do
    para "Good show, my friend! The ", code("join"),
      " method took that list of reversed lines and put them ",
      "together into a string. (Sure, you could have also just ",
      "used ", code("to_s"), ".)"
    para "To separate the poem into individual words, we can split it: ",
      prompt('poem.split(" ")')
    next_when_command :code => /split/, :answer => Array
  end




  lesson "Rate your Books"

  page "Of All the Chapters, No. 4 is Here Now" do
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
      link("here", :click => "http://ruby-doc.org/core-1.9/classes/String.html"),
      ". Go ahead and try a few (such as ", code("poem.downcase"),
      " or ", code("poem.delete"), ".)"
    para "When you're ready to move on, type: ", prompt("books = {}")
    next_when_command :code => /=/, :answer => {}
  end

  page "A Wee Blank Book" do
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
    next_when_command :code => /\[.+=/, :answer => Symbol
  end

  page "More Bite-Size Reviews" do
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
    next_when_command :code => /length|size/, :answer => (3..9)
  end

  page "Wait, Did I Like Gravity's Rainbow?" do
    para "See, the ", code("length"), " method works on strings, ",
      "lists and hashes. One great thing about Ruby is that names ",
      "are often reused. That's fewer names you need to remember."
    para "If you'd like to look up one of your old reviews, again ",
      "put the title in the square.  But leave off the equals."
    para "Just like this: ", prompt('books["Gravity\'s Rainbow"]')
    next_when_command :code => /\[/, :answer => Symbol
  end

  page "Hashes as Pairs" do
    para "Keep in mind that hashes won't keep things in order. ",
      "That's not their job. It'll just pair up two things: a ",
      strong("key"), " and a ", strong("value"), ".  In your reviews, ",
      "the key is the book's title and the value is the rating."
    para "If you want to just see the titles of the books you've ",
      "reviewed: ", prompt("books.keys")
    next_when_command :code => /keys/, :answer => Array
  end

  page "Are You Harsh?" do
    para "So are you giving out harsh, unfair reviews? ",
      "Let's keep score with this hash:\n", prompt("ratings = Hash.new {0}")
    para "Then, okay, now let's count up your reviews. Just stay with me. ",
      "Type:\n", prompt("books.values.each { |rate| ratings[rate] += 1 }")
    para em("(The straight line in the code is the pipe character,\n"+
        "probably located right above the Enter key on your keyboard.)")
    next_when_command :code => /\{.+\}/m, :answer => Array
  end

  page "A Tally" do
    para "Great, wow! You've made a scorecard of your ratings. ",
      "Type ", code("ratings"), " to see the count. This new hash ",
      "shows a rating and then the number of times you've given that rating."
    para "One of the amazing new things we've just used is a ",
      strong("block"), ". We're going to explore these more in the ",
      "next summary. But, basically, a block is a bit of Ruby code ",
      "surrounded by curly braces."
    para "Let's try another block: ", prompt('5.times { print "Odelay!" }')
    next_when_command :code => /\{.+\}/m,
      :answer => (3..20), :output => /\AOdelay!Od/i
  end



  
  lesson "Where are my Files?"

  page "Now Arriving at Chapter the 5th" do
    Dir.chdir(File.join(HH::HOME, 'root'))
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
    next_when_command :code => /entries/, :answer => Array
  end

  page "The Private Collection of Dr. Dir" do
    para "On your computer, you probably have a lot of different files. ",
      "Files with pictures in them, files with programs in them. ",
      "And files are often organized into folders, also called: ",
      strong("directories"), "."
    para "You've just listed out everything in the current directory. ",
      "The directory this tutorial is running in, indicated by a single dot. ",
      "Containing some programs and other tutorials and such."
    para "Let's see what's in the top folder on your hard drive: ",
      prompt('Dir.entries "/"')
    next_when_command :code => /entries/, :answer => Array
  end
  
  page "The Private Collection of Dr. Dir" do
    para "You've just listed out everything in the top directory. The",
      " root directory, indicated by a single slash."
    para "So, what is the ", code('Dir.entries'), " method? Well, it's",
      " just a method, right?", code('entries'), " is a method called on",
      " the ", code('Dir'), " variable. And ", code('Dir'), " has a ",
      " collection of methods for checking out file directories."
    para "One other little thing we haven't really talked about openly. ",
      "Method arguments, highlighted in green."

    item code('Dir.entries "/"'), ": Anything listed after a method",
      " is considered an attachment."
    item code('print poem'), ": See, ", code('print'), " is an ordinary",
      " method. And the poem is attached. To be printed."
    item code('print "pre", "event", "ual", "ism"'), " has several",
      " arguments, with commas between them."
    para "To list just the text files in that directory: ",
      prompt('Dir["*.txt"]')
    next_when_command :code => /\*\.txt/, :answer => Array
  end
  
  page "Come, Read Comics With Me" do
    para "The ", code("Dir[]"), " method is like ", code("entries"), " but you",
      " search for files with wildcard characters. Here, we see those square",
      " brackets again! Notice how they still mean, \"I am looking for _____?\""
    para "More specifically: \"I am looking for files which end with ", code('.txt'), ".\""
    para "Let's crack open this comics file, then. Here's the way: "
    para prompt('print File.read("comics.txt")')
    next_when_command :output => /Achewood.+/
  end

  page "Mi Comicas, Tu Comicas" do
    para "All right! We can start to use files to store things. This is",
      " great because normally when we exit Ruby, all our variables will",
      " be gone. Ruby, by itself, forgets these things. But if we save",
      " things in files, we can read those files in future Ruby escapades."
    para "Hey, and guess what? The ", code("Home"), " directory is yours! I gave it to you! I am generous! Let's make a copy of the comics file."
    para "You'll want to: ", prompt("FileUtils.copy('comics.txt', 'Home/comics.txt')")
    para em("If you've already created the file, use File.delete('Home/comics.txt') to trash it.")
    next_when_command :code => /FileUtils/
  end
  
  page "Your Own Turf" do
    para "Okay, you've got a copy. Check it: ",
      code('Dir["Home/*.txt"]')
    para "To add your own comic to the list, let's open the file in ",
      strong('append'), " mode."
    para "Do it like this:"
    para prompt('File.open("Home/comics.txt", "a") do |f|'), "."
    para "Then press Enter. Your prompt will change to two dots. Then this:"
    para prompt('f << "Cat and Girl: http://catandgirl.com/\n"')
    para "And another Enter. Finally, an ", prompt("end"), " should do it!"
    next_when_command :answer => File
  end




  lesson "Comics"

  page "Hallo, Who's There? And Summary #5 Waves Its Hat!" do
    Dir.chdir(File.join(HH::HOME, 'root'))
    para "Well done, well done, well done, well done! Truly, truly, ",
      "truly, truly, truuuuuuuuly!"
    para "Here's the last few minutes of your life in review:"
    item strong('Files.'), "What more can be said? Lots of methods for",
      "editing files and lookin around in directories."
    item strong('Arguments.'), "Arguments are a list of things sent into",
      "a method. With commas between."
    item "We also spoke about ", strong('do'), " and ", strong('end'),
      " which are another way to make a block."
    para "You totally know how to use Ruby now. I mean you've got down the",
      " essentials. You just need to keep learning more methods and",
      " try out more complex blocks."
    para "But there's one side of Ruby we haven't settled. Making your own",
      " methods and classes. "
    para em('Ahem!'), " Let's get it over with then."
    para "Try this: "
    item prompt('def say_hello( name )')
    item prompt(' puts "Hello, " + name')
    item prompt('end')
    next_when_command :code => /def\s+say_hello/, :answer => nil
  end

  page "In Ruby, Def Leppard Means Define Leppard (a Method)!" do
    para "Hey, okay, you done it. You're making your own method. You started",
      " with ", code('def'), ", followed by the name of the method."
    para "And a list of arguments which the method will need. This isn't too",
      " scary and dangerous!"
    para "now try it out:"
    para prompt('say_hello("Steve")')
    next_when_command :code => /^\s+\w+\s+$/, :output => /\s+/, :answer => nil
  end
  
  page "Once again, with feeling!" do
    para "Awesome! Once you make your own methods, you can call them just",
      " like you would any other method."
    para "That was a pretty simple method. Let's try a bigger one, with",
      " our comics.txt file."
    item prompt('def load_comics( path )')
    item prompt('  comics = {}')
    item prompt('  File.foreach(path) do |line|')
    item prompt('    name, url = line.split(\': \')')
    item prompt('    comics[name] = url.strip')
    item prompt('  end')
    item prompt('  comics')
    item prompt('end')
    next_when_command :code => /def.*File/, :answer => nil
  end

  page "The Ripened Fruit of Your Own Creation" do
    para "A new method is born. Let us use it: ",
      prompt("comics = load_comics('comics.txt')")
    para em('If you have a problem, you might have mistyped. Go to the ' +
        'previous page and try again')
    next_when_command :code => /=/, :answer => Hash
  end
  
  page "Hey, Cool, a Comics Thing" do
    para "In your Ruby window above, look at the code you've typed for the ",
      code('load_comics'), " method. What is happening? You're passing in the",
      code('path'), " variable and you're getting back the ",
      code('comics'), " variable. Ruby lets the ",
      code('comics'), " hash trickle out the end of the method."
    para "A number of methods were used to get the job done. See if you can spot them."
    item strong('File.foreach'), " is a method which opens a file and ",
      "hands each line to the block. The ",
      code('line'), " variable inside the ", code('do...end'),
      " block took turns with each line in the file."
    item strong('split'), " is a method for strings, which breaks the",
      " string up into an array. An axe is laid on the colon and the",
      " line is chopped in half, giving us the ", code('url'),
      " and ", code('name'),' for each comic.'
    item strong('strip'), " removes extra spaces around the name. Just in case."
    para "Right on. Bravo. You've got the comics in a Ruby hash. But what now?"
    " What good is this really? What if you needed more than just a URL?"
    para "To glimpse into the future, try this: ",
      prompt("{  }.class")
    next_when_command :code => /class/, :answer => Class
  end




  lesson "Blog"

  page "Summary #6 Which Means You've Come So Far" do
    para "You're a level six Ruby cleric. I mean what a great job you've done. Let's review:"
    para "So what could possibly be next? What could you possibly have to learn now?",
      "Ha, this is the best part. You've come such a long way that we're going",
      " to uncover classes. For two more short lessons and you're done."
    para "Earlier, we created a hash like this: ", prompt('Hash.new'), " Try it."
    next_when_command :code => /Hash/, :answer => Hash
  end
  
  page "Not a School Class, a Working Class" do
    para "You see, the empty curly braces ", code('{}'), " is a shortcut for ",
      code('Hash.new'), ". The ", code('new'), " method is used to make objects ",
      " of a certain class. (Think \"class\" as in \"working class\"; a specific ",
      "group of objects which are similar, have the same jobs, the same shirts.)"
    para "Ask yourself this: ", em('How would I make a blog in Ruby?')
    para " Where would you start? Well, you might store your blog entries in a ",
      "file, right? But how would you keep track of the title of the entry and ",
      "the time it was posted? And when you loaded the file, how would it look ",
      "in Ruby? Would it be a Hash? Or an Array? Or an Array of Arrays? Or something else?"
    para "I really think you'll want to use a class. You are already familiar with ",
      "many classes: ", code('Hash'), ", ", code('Array'), ", ", code('String'), "."
    para "Let's make a new class: "
    item prompt('class BlogEntry')
    item prompt('end')
    next_when_command :code => /class BlogEntry/, :answer => nil
  end
  
  page "The Stuff Blogs are Made of" do
    para "You've opened up a new ", code('BlogEntry'), " class. What is your blog entry ",
      "made of? A title, sure. Also, a time when the entry was posted. The full text of the entry."
    para "We'll do a mood setting, too, just like LiveJournal. "
    para "Okay, so you know how to make a class. Let's try that again, and :"
    item prompt('class BlogEntry')
    item prompt('  attr_accessor :title, :time, :fulltext, :mood')
    item prompt('end')
    next_when_command :code => /class BlogEntry/, :answer => nil
  end

  page "Accessors Are the Dangling Limbs" do
    para "Hey, good class, man. You've got a new ", code('BlogEntry'),
      " class. To start an entry: "
    item prompt('entry = BlogEntry.new'), "."
    para "In the class definition, you used a method called ",
      code('attr_accessor'), ". There are many ", strong('attr'), "ibute ",
      "methods like this which add little settings to classes. These ",
      "attributes are just variables attached to a class."
    para "Think of it this way. A class is like a person. That star-shaped ",
      "human thing out there. And the attributes are the dangling limbs, the ",
      " different parts that make up a body."
    para "To set the title of your entry: "
    item prompt('entry.title = "Today Mt. Hood Was Stolen!"')
    next_when_command :code => /entry/, :answer => String
  end
  
  page "An Object, That Neat Little Package" do
    para "Go ahead and set the post time:"
    item prompt('entry.time = Time.now')
    para "And the mood:"
    item prompt('entry.mood = :sick')
    para "And the post itself:"
    item prompt('entry.fulltext = "I can\'t believe Mt. Hood was stolen! I am speechless! It was stolen by a giraffe who drove away in his Cadillac Seville very nonchalant!!"')
    para "To see all your settings, just type at the prompt: "
    item prompt('entry'), "."
    next_when_command :code => /^entry$/, :answer => Object
  end
  
  page "Quickening it Up" do
    para "Cool, your blog is awesome. Hey, let's make things a bit easier on you.",
      "You're not going to want to set the time like that every time you post.",
      "You just want to type in the title and the entry and the mood quickly, right?"
    para "Let's add an ", code('initialize'), " method."
    item prompt('class BlogEntry')
    item prompt('  def initialize( title, mood, fulltext )')
    item prompt('    @time = Time.now')
    item prompt('    @title, @mood, @fulltext = title, mood, fulltext')
    item prompt('  end')
    item prompt('end')
    para "Once you've got that typed in, try making a new entry: ",
      prompt('BlogEntry.new')
    next_when_command :code => /^BlogEntry$/, :output => /method needs a bit more/
  end

  page "You've Taught Your Blog to Reject Worthless Things" do
    para "Did you see how inside the class we used the at-symbols? Like this: ",
      code('@time = Time.now')
    para 'Outside the class, we use accessors: ',
      code('entry.time = Time.now'),
      "But inside we use ", em('instance variables'), ": ", code('@time = Time.now'),
      "They're the exact same thing, but expressed in two different places of your program."
    para "Your blog now needs a title, a mood and a post in order to work. When a new ",
      code('BlogEntry'), " is created, the ", code('initialize'),
      "method is used to check for any arguments to ", code('new'), ". Uh, we need three arguments!"
    para "Try it again with all three."
    para prompt('entry2 = BlogEntry.new( "I Left my Hoodie on the Mountain!", :confused, "I am never going back to that mountain and I hope a giraffe steals it." )')
    next_when_command :code => /entry/, :answer => Object
  end
  @match = [/entry/, Object]




  lesson "Combining Things"

  page 'A Giraffe Has Not Stolen Summary #7' do
    para "Aha, you're here. And all in one piece. We're still going to make",
      " your blog real, but until then, let's review, okay?"
    item strong('Classes.'), " Everything in Ruby is some kind of object. ",
      "Classes explain how a certain object works. For example, you",
      " made a few blog entry objects and these objects are explained in the ",
      code('BlogEntry'), " class. In other words: you call them BlogEntry objects."
    item strong('Accessors'), " are variables attached to an object which can be used ",
      em('outside'), " the object. (", code('entry.time = Time.now'), ")"
    item strong('Instance variables'), " are the same variables you're using for accessors",
      " when ", em('inside'), " the object. Like in a method definition. (",
      code('@time = Time.now'), ")"
    para "Okay, let's wrap things up, kid. Here's the last chapter of the GRIPPING epic",
      " story of Try Ruby! Now that you've got a taste of how it all works, how",
      " are you going to use it around the house and in your grocer's freezer?"
    para "Let's finish your blog. You have blog entries, but no actual blog."
    para "Put the entries into an array: ", code('blog = [entry, entry2]')
    next_when_command :code => /blog/, :answer => Array
  end

  page "It's All About Combining Things" do
    para "Some beautiful things can be done with the simple parts of Ruby, especially",
      " when you combine them together into new things. Here we've got a blog",
      " made of an array of classes. And, actually, Ruby really does good with",
      " this kind of creature."
    para "Here's a few things you can do with your array blog:"
    item "You'll want to sort your entries from newest to oldest. You can do this with: ",
      code('blog.sort_by { |entry| entry.time }.reverse')
    item 'If you want to search your blog for anything related to "cadillac": ',
      code('blog.find_all { |entry| entry.fulltext.match(/cadillac/i) }'),
      "the slashy ", code('/giraffe/i'), " is a Regexp object, used for matching words."
    item "Add new entries with ",
      code('blog << new_entry')
    para "You can browse a list of all Ruby's built-in methods at ", strong('http://ruby-doc.org/core/'), " ."
    para "One ", em('really'), " useful method (I probably use this more than anything else) is ",
      code('map'), ". Type: ",
      prompt('blog.map { |entry| entry.mood }')
    next_when_command :code => /mood/, :answer => Array
  end
  
  page "That Map's not on Google" do
    para "Okay, actually, Enumerable#map is.",
      "(That means the ", code('map'), " method of the ", code('Enumerable'), " class, by the way.)"
    para "Anyway, it's called ", code('map'), " because you're mapping one Array to another. ",
      "See how you called that method on an Array, and you got one back? This map is showing the way",
      " from each BlogEntry to each mood."
    para "What other things would you want to do with a list of things? How about adding them together?"
    para "A map won't work for that, because we need to come up with one answer, not a list of them!",
      " For this job, we'll need ", code('inject'), ". Try it:"
    para prompt('[1, 2, 3, 4, 5].inject {|sum, n| sum + n }')
    next_when_command :code => /inject/, :answer => Fixnum
  end

  page "Shove those numbers in there!" do
    para "The ", code('inject'), " method takes a block with two arguments, ",
      "and gives back a single answer! We keep shoving elements of the array ",
      "into the block over and over again, and end up with a Last Element Standing."
    para "In this case, we've used + to add them all together. Groovy!"
    para prompt('[1, 2, 3, 4, 5].inject {|sum, n| sum + n }')
    next_when_command :code => /inject/, :answer => Fixnum
  end



  lesson "Smartiac you Are"
  page "Summary #8, The Hey-Relax-You-Did-Good Summary" do
    para "You really deserve a double-layer cake with double-double frosting and a",
      " guy playing one of those guitars that's a double guitar. I mean you",
      " finished, you really did! No doubt about it, you're a certified",
      " red-blooded smartiac!"
  end
end