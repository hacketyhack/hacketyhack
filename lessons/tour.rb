lesson_set "Hackety Hack" do
  lesson "Your first program"
  page "Let's Get Going, Shall We?" do flow do
    para "This whole dark area is the ", em("Hackety Hack Tutor"),
          ". Okay, to take the tour click on the ", em("Next"), " button ("
    icon_button :arrow_right, nil do
      alert "You should click on the actual button, below! =)"
    end
    para ")"
  end end

  page "The Tutor Controls" do
    para "Before we get jump in, just take a minute to look at the controls in the bar below."
    flow do
      icon_button :arrow_left, nil
      para strong("back"), ": goes back one page"
    end
    flow do
      icon_button :arrow_right, nil
      para strong("continue"), ": goes to the next page"
    end
    flow do
      icon_button :menu, nil
      para strong("menu"), ": makes it easy to jump around to any lesson"
    end
    flow do
      icon_button :x, nil
      para strong("close"), ": closes the tutor"
    end
  end

  page "Coming Back to the Tutor" do flow do
    para "Clicking the close button at the bottom will stop the tutor. ",
      "To come back to it, no problem, just click the lightbulb ( "
    image "#{HH::STATIC}/tab-tour.png", :margin => 6
    para ") in the tabbar on your left. Then click on the Lesson Set you were ",
      " following and you'll go back to the lesson where you left off.  ",
      strong("Give it a try right now")
  end end

  #lesson "Asking and Saving"

  # the flow is to have the image in the same line as the text
  page "Your first program" do flow do
    para "Let's start with a very simple program.\n"
    para "Click on the "
    image "#{HH::STATIC}/tab-new.png", :margin => 6
    para "icon in the tab bar on the left."
    next_when :tab_opened, :Editor
  end end

  page "Asking" do
    para "In the large box, type the following code exactly as written:"
    embed_code "# Asking and saying\n" +
      'name = ask("Your name please?")' + "\n" +
      "puts(name)"
    para "Click ", em("Run"), " when you're finished."
    next_when :program_run, :code => /\Wask\W.*\Walert\W/
  end

  page "Okay, what happened?" do
    para "The code you've written is for a language called ", em("Ruby"),
      ", which is the language spoken inside Hackety Hack."
    para "Now, take a moment to look at the program. See if you can figure ",
      "out how it works.  What do you suppose the ", code("ask"),
      " command does? And what is that ", code("name"), " word for?"
  end

  page "Let's Hang on to This" do
    para "Now ", em("Save"), " the program.  Call it ", em("Asking"), ". "
    flow do
      para "After that, click on the ", em("Home"), " icon ( "
      image "#{HH::STATIC}/tab-home.png", :margin => 6
      para ") in the tab bar."
    next_when :tab_opened, :Home
    end
  end

  page "Your Saved Programs" do
    para "Notice that the program is listed under ", em("Programs"),
      " You should see the name ", em("Asking"), " and, underneath it, ",
      "the short description ", em("Asking and saying"), ". Well done!"
  end

  page "A Note About Saving" do
    para "In the first line of your program, you placed a short comment. ",
      "Comments start with the number sign.  That criss-cross",
      "chex mix thing.  Comments are ignored by Ruby."
    para "However, Hackety Hack will check the beginning of your program for a",
      " comment.  If one is found, it will be used as the description. ",
      strong("Thank you so much Hackety Hack!!")
  end

  page "How Asking Works" do
    para "The ", code("ask"), " command you used in pops up a window ",
      "and lets the person at the computer type something in.  Whatever they ",
      "end up typing is handed back to your program.  In Part A, you stored ",
      "the typing in the ", code("name"), " variable."

    para "So how does Ruby know that ", code("ask"), " is a command and ",
      code("name"), " is a variable?  Because of their position in the ",
      "\"sentences\" of your code.  For example, variables are created with ",
      "an equals sign. Since ", code("name"), " comes before the equals ",
      "sign, it is a variable."

      embed_code 'name = ask("Your name please?")'

      para "Part of coding is simply just spotting the order of things."

      para strong("EXTRA CREDIT"), ": Try changing the question to something ",
        "a bit meaner. Make your program all crabby."
  end

  page "Saying" do
    para "Click on the name of your program ", em("Asking"), " to go back to ",
      "editing it. We're going to do something else with that name."

    para "Here's the new program (the first 2 lines are the same):"
    embed_code "# Asking and saying\n" +
      'name = ask("Your name please?")' + "\n" +
      'puts("Your name is #{name.length()} letters long")'

    para "Type this one in carefully. You'll notice in the quotes that there ",
      "is a little number sign and some curly braces.  The curly braces are ",
      "right above your square bracket keys (on a US keyboard.)"
  end

  page "All Typed In?" do
    para "Click ", em("Save"), " to save what you've done so far.  Then, ",
    em("Run.")

    para "Did you notice the words change? That is what the ", code("say"),
      " command did, changing those words!"
  end

  page "What's it Good For?" do
    para "The ", code("say"), " command is nice, because you can tell the ",
      "person at the computer what's going on while they're waiting.  You can ",
      "say ", strong("sending e-mail"), " or ", strong("downloading mp3"),
      " or ", strong("just crunching away..."), " depending on what your ",
      "program is doing.  It's a very simple thing, but hey.. this is only ",
      "lesson 1!!"

    para "We'll skip explanation of the other stuff for now, but run the ",
      "program a few more times and see if you can tell for yourself:"
    item "What does ", code('name.length()'), " do?"
    item "What's that thing surrounding it? ", code('#{....}')
  end

  page "Counting" do
    para "Okay, again: keep the first two lines of the program and go like this:"
    embed_code "# Asking and saying\n" +
      'name = ask("Your name please?")' + "\n" +
      "1.upto(name.length()) do |x|\n" +
      '  puts "Your name has #{x} letters."' + "\n" +
      "end"

    para "Notice the pipe symbols in the program.  At the end of the third ",
      "line, you'll see ", code("|x|"), ". Those two lines around the ",
      code("x"), " are pipe symbols. They are like a little waterslide that ",
      code("x"), " is shooting down. The pipe symbol is right above your ",
      "Enter key.  Press shift and that key and you'll see a pipe."
  end

  page "upto" do
    para "Just like ", code("ask"), " and ", code("say"), " are commands, so also ",
      "is ", code("upto"), " a command. But why does it have a dot before it?  ",
      "Why is it attached to the number 1?"

    para "Every command has a front and a back.  The front of a command can ",
      "attach to something with a dot.  The back of a command can attach to ",
      "something with parentheses."

    embed_code(
      "1.upto(6) do |x|\n" +
      "  say(\"Holding up \#{x} fingers\")\n" +
      "end")

    para "The ", code("upto"), " command is a part of every number.  In this ",
      "case, it is a part of the number 1.  Think of it as a vicious dog that ",
      "has a leash to its owner.  The dot is the leash."
  end

  page "Upto the Dog" do
    embed_code "1.upto(6) do |x|"
    para "Back to the dog analogy!  So, the parentheses are the dog's mouth, ",
      "eating the number six.  The thing to remember is: commands are owned ",
      "by whatever is on the left-side of the dot.  And its gobbling up ",
      "everything in the parentheses.  This gives the command energy to do ",
      "its job!!  You know: Scooby Snacks."

    embed_code('"Hello?".upto(6)')

    para "See, that won't work.  Because quoted things don't own a dog called ",
      code("upto"), ". Because ", code("upto"), " is for counting!!"

    para "We're counting from 1 ", em("up to"), " 6.  Nice and easy to read."
  end

  page "Lesson One Complete!" do
    para "At this point, you probably have a lot of questions and you may ",
      "feel that there's a lot of unexplained stuff in there.  Well, of ",
      "course there is!!  You can't just know everything right away.  But you ",
      "have learned some things:"

    item strong("Commands"), " do things, just like ", em("dogs"), " do things."
    item strong("Variables"), em(" store "), "things."
    item "You create a variable with ", strong("an equals sign"),
      ". That's how Ruby knows -- by that equals sign!"
    item "Commands are owned by the thing on the left-side of the dot."
    item "Commands eat useful things in ", strong("parentheses"),
      ", as if they were biscuits."
    item "The commands ", code("ask"), ", ", code("say"), ", ", code("sleep"),
      " and ", code("upto"), " were explored a bit."

    para "That's pretty good, actually.  Take a rest, enjoy your accolades and ",
      "let your brain soak in what you've got so far."

    para strong("EXTRA CREDIT"), ": If you want to try stretching your brain a ",
      "bit further, try writing a program which blinks.  You can use the ",
      code("say"), " and ", code("sleep"), " commands to do it!!"
  end


  lesson "Getting Outdoors"

  page "What now?" do
    para "In Lesson One, we asked some things and we said somethings.  Not bad, ",
      "not bad.  But not incredibly useful, you know?  How about let's make ",
      "the computer do something?"

    para "Specifically: let's get outdoors and start writing code that can ",
      "connect to the Web."
  end

  page "Downloading" do
    flow do
      para "Start a new program.  (Just click on the "
      image "#{HH::STATIC}/tab-new.png", :margin => 6
      para ")"
    end

    embed_code "# A simple file downloader.\n" +
      'url = ask("Enter a Web address:")' + "\n" +
      'save_as = ask("Save the file as:")' + "\n" +
      'Web.download(url, save_as)'

    para "Save the program as ", strong("Downloader")
  end

  page "Running the Program" do
    para "This program asks twice.  In the first ", code("ask"),
      " box, type in an address to some file on the Web.  How about the Dead ",
      "Hensons' rendition of the \"Pinball Number Count\"?"

    para em("http://www.deadhensons.com/media/pinball_clip.mp3")

    para "Then, in the second box, type in a name for the downloaded file. ",
      "Like: ", em("pinball.mp3")

    para "What did the program do?  Can you tell just by looking at the code?"
  end

  page "Where Did the File Go?"  do
    para "So, you saw the file downloading, right?  Now to find where it ",
      "downloaded.  Hackety Hack keeps your downloaded files in a folder, ",
      "right next to where your programs are saved.  Let's go dig it up!"

    para strong(em(HH::USER))

    para "Go to the folder above (use Windows Explorer if you are on Windows, ",
      "or start at \"My Computer\" and click down through each folder)."
  end

  page "Your Hacks Folder"  do
    para "You should see a group of files ending in .rb, as well as a folder ",
      "marked ", strong("Downloads"), ". Aha! Each of the .rb files is one of ",
      "your programs. These are genuine Ruby programs you can pass around to ",
      "other Hackety Hackers.  If a friend gives you a script, you can copy ",
      "it into this folder and it will appear in Hackety Hack!"

    para "Now, check the ", strong("Downloads"), " folder.  Well, well, well. "
    "Fancy that. "
  end

  page "The Web Library" do
    para "To download the MP3, we use the ", code("Web.download"), " command. ",
      "This is just another command like ", code("ask"), " and ", code("say"),
      ", except that it is a part of Hackety Hack's Web library of commands. ",
      "(In Ruby, these commands are also called ", strong("methods"),
      ". Just so you know.)"

    para "To keep things organized, some commands are kept in libraries. ",
      "Stuff like ", code("Web.fetch"), ", ", code("Web.page"), " and ",
      code("Web.download"), " all happen to relate to working with the ",
      "Internet, so they are kept in the ", code("Web"), " library."
  end

  page "As For Your Private Library" do
    para "In upcoming lessons, you'll learn how to add your own libraries and ",
      "how to use libraries from other hackers.  This opens Hackety Hack up ",
      "to new commands that don't come with it."

    para strong("EXTRA CREDIT"), ": Hackety Hack comes with a command ",
      code("ask_save_file()"), " which is a special kind of ", code("ask"),
      ". See if you can change the third line of your program to use this ",
      "command."
  end

  page "Fetching (Not Saving!)" do
    para "While we're in the Web library, let's play with ",
      code("Web.fetch"), ". I mean you basically know everything there is ",
      "to know about ", code("Web.download"), ". It downloads files from ",
      "the Internet and saves them. ", strong("THE END"), "."

    para "But ", code("Web.fetch"), " is a bit smarter. It grabs things off ",
      "the Internet and, rather than saving, lets you play with the thing a ",
      "bit."
  end

  page "MeFi" do
    para "Here's the next example. Save this one as ", em("MeFi"), "."

    embed_code "# Read the Metafilter feed.\n" +
      'Web.fetch("http://xml.metafilter.com/rss.xml") do |feed|' + "\n" +
      "  puts feed\n" +
      "end"

    para "Run the script. You'll see Hackety Hack download a file... but ",
      "something else happens... hmmm!"
  end

  page "Blog, You Know?" do
    para "Metafilter is a blog.  So this example could work with any blog you ",
      "like. The Web address we're using here is Metafilter's news feed. ",
      "(Often sites will call this RSS or XML.  Often, blogs will have a ",
      "link in a sidebar or something.)"

    para "Here are a few other feeds:"
    item "http://digg.com/rss/index.xml"
    item "http://feeds.engadget.com/weblogsinc/engadget"
    item "http://feeds.feedburner.com/boingboing/iBag"
  end

  page "Playing With Fetch" do
    para "Okay, so we've got Metafilter's feed with all the latest news ",
      "posted on the blog.  So, then what?  What good is this?  Can't you ",
      "just go ", strong("straight to metafilter.com in a regular browser??")

    para "Let's add a few lines to our program:"
    embed_code "# Read the Metafilter feed.\n" +
      'Web.fetch("http://xml.metafilter.com/rss.xml") do |feed|' + "\n" +
      "  feed.items().reject!() do |item|\n" +
      "    item.description().length() > 200\n" +
      "  end\n" +
      "  puts( feed.items() )\n" +
      "end"
  end

  page "Ahh! Complicated!" do
    para "Okay, let's step through this program.  It's quite a bit more ",
      "complicated, isn't it?  But it's only five lines, so I think we can ",
      "figure it out."

    para "The Metafilter news gets saved in a variable called ", code("feed"),
      ". So we can play with it.  In line 3, the `reject!` command is used. ",
      "This command deletes things from a list.  And the news feed contains a ",
      "list of news ", code("item"), "s.  Hmmm.  How does this all fit ",
      "together?"

  end

  page "Hidden in the Feed " do

    para "On the previous page we wrote:"

    embed_code "puts( feed.items() )\n"

    para "When you run this, the ", code("items"), " will be listed as ",
      strong(em("an Array")), " which is a list of things."
  end

  page "Quickly, About Arrays" do
    para "You can create arrays (also known as \"lists\") with square ",
      "brackets."

    para "Try this little program. (You can hit Ctrl-Z to undo your changes ",
      "one-by-one and Ctrl-Y to redo those changes again.)"
    
    embed_code 'puts(["HELLO", 1, 2, 3])'

    para "As you can see, you put square brackets on each end. And commas ",
      "between each item. Like a caterpillar stapled to the screen. The ",
      "square brackets are the staples and the commas are the caterpillar's ",
      "legs."
  end

  page "Back to Reject!" do
    para "Now that we know that a blog feed is just an ordinary list of ",
      "things, we can start treating it like one.  The ", code("reject!"),
      " method will delete stuff from the list that we don't want. ",
      "It has an exclamation point ", strong("because it's dangerous!!"),
      " Kablewy. It deletes that stuff for good. "

    embed_code "# Read the Metafilter feed.\n" +
      'Web.fetch("http://xml.metafilter.com/rss.xml") do |feed|' + "\n" +
      "  feed.items().reject!() do |item|\n" +
      "    item.description().length() > 200\n" +
      "  end\n" +
      "  puts( feed.items() )\n" +
      "end"

    para "This program will remove any thing from the list which is longer ",
      "than 200 letters.  We just want to focus on the short little ",
      "Metafilter posts that show up sometimes.  We're not in the mood for ",
      "anything too long."
  end

  page "We Read a Feed in a Very Special Way" do
    para "AH!  So this is pretty handy, huh?  If you like blogs, this is just ",
      "the start.  You could write programs to watch your favorite blogs ",
      "for certain words.  You could write a program to only show items ",
      "containing MP3s.  And we'll get into some other fancy things soon ",
      "enough."
  end

  page "About the Do and End" do
    para "We're going to skip getting too detailed on the ", code("do ... end"),
      " part, except to say: it checks to find blog entries longer than 200 ",
      "letters.  But we saw this in the last lesson, when we counted ",
      code("upto"), ":"

    embed_code(
      "1.upto(6) do |x|\n" +
      "  puts(\"Holding up \#{x} fingers\")\n" +
      "end")

    para "This ", code("do ... end"), " section is called a ", strong("block"),
      ". It's usually slightly indented, but that's not necessary at all. ",
      "Indenting the block makes it stand out a bit more, to help us see it."
  end

  page "Lesson Two Meets a Timely End" do
    para "Well, that was thrilling!  You moved right off into doing some ",
      "useful things.  We started to grab stuff off the Web: downloading ",
      "files and fetching blogs."

    para "Here's a few programming bits you've picked up:"
    item "The ", strong("Web library"), " contains commands for horsing ",
      "around with the Internet."
    item code(strong("Web.download")), " saves files off the web."
    item "They get stored in ", strong("your Hackety Hack folder"), "."
    item "Your programs are saved in that folder, too!"
    item code(strong("Web.fetch")), " can grab blog feeds and web pages."
    item "You can dissect a feed and change it or get stuff out of it."
    item "Web feeds are just ", strong("a list of items"), "."
    item "A list is also called ", strong("an Array"), "."

    para "Very, very good.  I do say.  Take a break, eat a gigantic Dagwood "
      "sandwich, and please return when you are duly refreshed."
  end


#  lesson "Making a Blog"
#
#  page "" do
#    para "So, you're still trying to get comfortable with Ruby, but we've ",
#      "seen a lot more of what Hackety Hack can do.  Downloading and eating ",
#      "blogs, not bad."
#
#    para "But this lesson's going to hopscotch all that other stuff.  In this ",
#      "lesson, you'll learn to make your own blog in just a few lines!! ",
#      "And we'll start to figure out what all the little pieces are: ",
#      "strings, numbers, blocks.  Stuff like that."
#  end
#
#  page "window" do
#    para "Start up another new program.  Save this one as ", strong("Window"),
#      ":"
#
#    embed_code "# A simple window\n" +
#      "window do\n" +
#      '  title("My Page")' + "\n" +
#      '  para("This belongs to ____")' + "\n" +
#      "end"
#
#    para "You can put your name in where the blanks are. ", em("Save"), " it ",
#      "and ", em("Run"), " it."
#
#    para "We're using a few things we've seen before, but let's go over each ",
#      "of them, to be clear."
##  end
##
##  page "Modules and Methods" do
##    para "We've talked about modules.  What's the module in the code you ",
##      "just typed? (", em("Hint: only one is used"), ".)"
#
#    para "And we've talked about commands (also called ", strong("methods"),
#      ".)  What are the methods in the code? "
#  end
#
#  page "Let's See If You Were Right" do
#    #The module is the `Web` module.  It contains a method called
#    #`popup` that we want to use.
#    para "There are three methods in all: ", code("Web.popup"), ", ",
#      code("title"), " and ", code("para"), "."
#
#    para "The ", code("para"), " method means \"paragraph\" here."
#
#  end
#
#  page "Blocks" do
#    para "Attached to ", code("window"), " is a block."
#
#    embed_code "window do\n" +
#      "  ...\n" +
#      "end\n"
#
#    para "The block is everything between ", code("do"), " and ", code("end"),
#      ".  A block is a group of code attached to a command. Again: a ",
#      strong("group of code"), " attached to a method."
#
#    para "A block is like ", strong("a new lung"), ". You plug it in to make a ",
#      "method breathe.  The ", code("Web.popup"), " method gives its block one ",
#      "puff of air. And the block uses that puff of air to make all the parts ",
#      "that go inside the popup.  One popup, made in one puff of air."
#  end
#
#  page "Blocks (cont'd.)" do
#    para "We used a block a few other times.  Here's one:"
#
#    embed_code(
#      "1.upto(6) do |x|\n" +
#      "  say(\"Holding up \#{x} fingers\")\n" +
#      "  sleep 1\n" +
#      "end")
#
#    para "In this one, the block gets ", strong("six puffs of air"),
#      ". Every time we count a new number, the block gets a puff.  ",
#      "And it uses that puff to say something and take a short nap."
#
#    para "Puff.  Puff.  Puff.  Puff.  Puff.  Puff!  And after that sixth one, ",
#      "that block's life is over and done."
#  end
#
#  page "So, Is It Totally Disassembled?" do
#    para "Okay, so we've almost finished taking this apart:"
#
#    embed_code "# A simple window\n" +
#      "window do\n" +
#      '  title("My Page")' + "\n" +
#      '  para("This belongs to ____")' + "\n" +
#      "end"
#    para "First, we have the ", code("window"), " method, which ",
#      "is attached to a block, an iron lung that gets turned on and handed",
#      "a puff of air.  In the block, the `title` and `para` commands run."
#  end
#
#
#  page "Words in Strings" do
#    para "Let's talk about the quoted phrases."
#    embed_code '"My Page"'
#
#    para "This is a string.  It's a short string of letters.  When you think ",
#      '"string", just imagine each letter is ',
#      strong("clipped to a clothesline"), ". The little quotes are the clips ",
#      "on each end, hooked on to theclothesline."
#  end
#
#  page "Upsy Reversy" do
#    para "Strings are great for messing with words.  Try changing the third ",
#      "line to:"
#    embed_code 'title("My Page".upcase().reverse())'
#
#    para "And run it. And think about that."
#
#    para "What is ", code("title"), "? And what are ", code("upcase"),
#      " and ", code("reverse"), "??"
#  end
#
#  page "A Blog Window" do
#    para "Let's change the insides of the popup a bit.  Instead, we want to ",
#      "add a new blog entry."
#
##{{{
###!ruby
### Write in my blog
##Web.popup() do
##  title("Add a blog entry")
##  editline("Title")
##  editbox()
##  buttons("cancel", "save")
##end
##}}}
#
##'''Save''' the program as '''WriteMyBlog'''.  '''Run.'''  Hey, neat!
##Try typing in a short blog entry and saving.
#
#  end
#
#  page "Well, Not Really" do
#    para "Hmm.  Actually.  That didn't save anywhere.  It's gone!!  You lost ",
#      "your precious blog entry!!  That is unacceptable."
#
#      "Let's change the line defining the button:"
#
##{{{
###!ruby
##Web.popup('MyBlog') do
##}}}
#
#    para "That tells Hackety Hack to attach the button to the ",
#      strong("MyBlog"), " table. Try running it again and typing in a blog ",
#      "entry.  How'd that go??"
#
#    para  "While you're at it, save a few more blog entries.  Get it going."
#  end
#
#  page "About Tables" do
#    para "Tables are empty boxes in Hackety Hack where you can store things.",
#      "Each box will contain the same kinds of things.  So in the ",
#      strong("MyBlog"), " box, we'll be storing blog entries."
#
#    para "What's a blog entry?  Well, in the popup we have an ",
#      code("editline"), " for the title and an ", code("editbox"),
#      " for typing the main blog paragraphs. So, based on the popup we made, ",
#      "a blog entry is a title and a bunch of paragraphs."
#  end
#
#  page "What are Tables?" do
#    para "Tables are a great place to stuff links or journal entries or ",
#      "pictures or... anything really.  And links could go in a ",
#      strong("MyLinks"), " table and journals in a ", strong("ClaspedDiary"),
#      " table...  You know?"
#
#    para "Your tables are all kept in your Hacks folder, right next to your ",
#      "programs.  There's a file called ", strong("+TABLES"), ". That file!"
#  end

##  page "Reading the Blog" do
##
##Go start another new program.
##
##{{{
###!ruby
### Read my blog
##blog = Table('MyBlog').recent(10)
##puts blog
##}}}
##
##Save this one as '''ReadMyBlog'''.  And run it, of course!!
##
##The `Table('MyBlog')` command opens up the the blog table you've been adding
#to.  And the `recent` method grabs a certain number of the latest
#blog entries.  In this case: #'''the most recent ten entries.'''
#
#end
#
#== Lesson 3C: And Another Hack ==
#
#Oh, also worth trying:
#
#{{{
##!ruby
## Read my blog
#blog = Table(#'MyBlog').recent(10)
#Web.popup do
#  puts blog
#end
#}}}
#
#What else can you do with tables?  Well, we#'ll get into that.
##
##= Lesson Three is In The Bag =
##
##Wonderful, you've made a very simple blog.  We'll add some color
##to it later.  But look at all you learned:
##
## * You used `Web.popup` to make a little web page in a box.
## * '''Strings''' are letters inside quotes.  (Clipped to a clothesline.)
## * Popups can be attached to tables, for saving.
## * '''Tables''' store things, in order.  Your blog entries were
##   each saved in the '''MyBlog''' table.
## * Tables have a `recent` method for getting the latest stuff
##   added to the table.
##
##For now, have a rest.  The next lesson will be short, but you
##deserve a break after making your own super special blog.
##
##'''EXTRA CREDIT:''' Tables also have an `all` method that gives
##you back everything inside the table.  Change your blog to show
##everything rather than just the most recent.

  lesson "The Ruby Language"

  page "Cheating" do
    para "You've done some useful things.  Downloaded files, built a simple ",
      "blog.  And lots more ahead.  But let's stop and figure out how to ",
      "speed up your learning."

    flow do
      para "In the tab bar of Hackety Hack, you'll see a series of little ",
        "icons: a little house, a lightbulb.  Click on the "
      image "#{HH::STATIC}/tab-cheat.png", :margin => 6
      para"icon. This icon brings up the Cheat Sheet."
    end
    
    next_when :tab_opened, :Cheat
  end

  page "I Recommend That You Cheat Immediately" do
    para "You don't need to read the whole thing just yet.  We're just going ",
      "to glance over a few parts of it to get you comfortable with reading ",
      "the Cheat Sheet.  You can keep this out while you're writing ",
      "programs in the main window."
  end

  page "Try Ruby" do
    flow do
      para "When you want to try out some code, just to see what happens, ",
        "with no need to save anything, you can use the ", strong("Try Ruby"),
        " tab. To open it click on the "
      image "#{HH::STATIC}/tab-try.png", :margin => 6
      para "icon."
    end
    next_when :tab_opened, :Console
  end

  page "Numbers" do
    para "Let's read the second box on the Cheat Sheet, which talks about ",
      "Numbers. ", em("Any Series of Digits.")

    para "Each box on the Cheat Sheet is carefully put together.  On the left ",
      "side, the title of the topic with an easy description.  A Number. ",
      "What is a Number?  It's any series of digits!  And, on the right ",
      "side is a few short examples with the numbers highlighted in a color."
  end

  page "Looking at the Numbers Examples" do
    para "The two examples here illustrate two uses of numbers: first, ",
      "multiplying a number.  And, second, using a number with a method and ",
      "a block."

    para "In the main window, start a new program.  Let's get multiplication ",
      "working.  Type in the following into the Try Ruby box: "

    embed_code "days = years * 365"

    next_when :try_ruby_command_error, :error => NameError

    #para strong("Run"), " it."
  end

  page "Days and Years" do
    para "Did it work? (It did not.) "
    para "So, how can we fix this program?  Try setting the ", code("years"),
      " variable right before running that code."

    para "And also add at the end: ", code("puts days")

    para "Any luck?"
    
    on_event :try_ruby_command, :code => /=/, :answer => Numeric do
      next_when :try_ruby_command, :code => /puts/, :answer => nil
    end
  end

  page "On to the Times" do
    para "Move to the second example on the cheat sheet. Try:"

    embed_code '5.times { puts "Odelay!" }'

    next_when :try_ruby_command,
      :code => /\.times/, :output => /.+/, :answer => (2..20)
  end

  page "Numbers are done" do
    para "And that's it.  These two examples are the key to using numbers. ",
      "Numbers are for math.  Or numbers are for repeating something. "
  end

  page "Arrays" do
    para "Move down to the fifth box on the cheat sheet. ", strong("Arrays"),
      ". ",  em("A List of Things."), " We've seen Arrays before, too. ",
      "So much is familiar to you already."

    para "The Cheat Sheet gives another two examples to jog your memory about ",
      "how Arrays work.  The first example makes an Array of book titles."

    embed_code 'books = ["Don Quixote", "Bluebeard"]'

    para "Then ", code("puts"),  " the variable you're storing the Array in!"

    on_event :try_ruby_command, :code => /=/, :answer => Array do
      next_when :try_ruby_command, 
        :code => /puts/, :answer => nil, :output => /./
    end
  end

  page "Briefly, More Arrays" do
    para "The second example in the Array cheat sheet has a bunch of ",
      "variables named ", code("one"), ", ", code("two"), " and so on. The ",
      "example makes an Array and then runs the ", code("each"),
      " method with a block."

    para strong("For EXTRA CREDIT"), ": get that ", code("each"),
      " method and its block hooked on to the ", code("books"), " array!"
  end

#  page "Using Help" do
#    para "Keep the cheat sheet open to the ", strong("Array"),
#      " section. Now go back to the main window and click the ",
#      strong("purple books icon") (right next to the magic wand.)

##This is the help manual!  Click on '''Ruby''' on the left-hand side.
##A little submenu opened up.  Now, click on '''Array'''.
##
##Every help page has a big, helpful summary at the top!
##'''An Array is a list of things. Especially useful when you have some
#things you want to keep in a specific order.#'''
##
##== Lesson 4A: Scroll Down ==
##
##The cheat sheet section on Arrays is just a small box.  Not too
##much stuff there, just enough to get you thinking.
##
##But in the help page on Arrays, you can scroll down for several
##pages, explaining the different methods available on an Array.
##
##So: if you need to just remember some basic things, check the Cheat
##Sheet.  If you need a lot more, hit the help pages.
##
##== Lesson 4B: Sample Programs ==
##
##Close the help pages and return to the cheat sheet window.  Scroll
##down, looking over each of the boxes.  There are about ten boxes
##there -- blocks, methods, assorted things.  This is so handy!  It's
#all the basics of Ruby wrapped up in one page.
#
#After those examples are a handful of sample programs.  In fact,
#these are programs you wrote in the last few lessons.  You can
#safely delete any programs you don#'t want any more, because they are
##here on the Cheat Sheet in case you need them again.
##
##== Lesson 4B: Deleting Programs and Tables ==
##
##We're finished with the cheat sheet, you can put it away.  Go to the
#main Hackety Hack window by hitting the house icon.
#
#Each Saved Program and Saved Table has its own little icon.  Place
#your mouse over one of those icons.  A menu appears!
#
#In each menu is a #'''Delete this''' link.  Use this link to scrap
#any of your programs or tables.  Once deleted,
#they will be gone forever, but that#'s the whole idea, right?
##
##== Lesson 4B: Emptying the Blog ==
##
##If you'd like to empty out your blog entries, go ahead and delete
#the #'''MyBlog''' table by clicking its delete link.
#
##'''EXTRA CREDIT:''' try changing the name of your blog table in the
#program from last lesson.  Add a few entries and come back to the
#home page.  Did it show up?
#
#= Adieu to a Short-Lived Lesson Four =
#
#That was a quick, little lesson, yeh?
#
# * You saw the #'''cheat sheet''', which is nice if you forget
#   how to make an Array or a String and need to refresh.
# * The #'''help pages''' are much, much deeper, with long
#   pages on absolutely anything you need help with.
# * Every saved program and table has its own menu.
# * In this menu, you#'ve got a '''Delete this''' link.
##
##Ready to push off again??

end
