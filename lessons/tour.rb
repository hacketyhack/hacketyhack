lesson_set "Hackety Hack" do
  lesson "Your first program"
  page "Let's Get Going, Shall We?" do flow do
    para "Welcome to your very first lesson in hacking!"
    para "This whole side of the screen is the ", em("Hackety Hack Tutor"),
          ". You can move forward through the lessons by clicking the ", 
          em("Next"), " button ("
    icon_button :arrow_right, nil do
      alert "You should click on the actual button, below! =)"
    end
    para "). Give it a shot!"
  end end

  page "The Tutor Controls" do
    para "Before we jump right in, just take a minute to look at the controls in the bar below."
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
    para "Don't forget! Press "
    icon_button :arrow_right, nil
    para "to move to the next lesson. Have at it!"
  end

  # the flow is to have the image in the same line as the text
  page "Coming Back to your lesson" do flow do
    para "Clicking the close button at the bottom will stop the lesson. ",
      "To come back to it is easy as pie! Just click the lightbulb ( "
    image "#{HH::STATIC}/tab-tour.png", :margin => 6
    para ") in the sidebar on the far left. Then click on the Lesson Set you were ",
      " following and you'll go back to the lesson, right where you left off!  ",
      strong("Give it a try right now")
  end end
  
  page "A small aside about programming" do
    para "Let's have a small chat about programming before we write your ",
         "first program."
    para "When we build software, we often talk about ", em("writing"), " programs. ",
         "This is no accident; computers speak ", em("languages"), " just like ",
         "people do! Well, almost just like people. Computers are kind of stupid ",
         "and so their languages are much simpler than human languages. English ",
         "is far more complicated than anything a computer can understand!"
    para "In this tutorial, you'll be learning a computer language called ",
          em("Ruby"), ". "
  end
  
  page "A small aside about Ruby" do
    para "Ruby was written by an upstanding guy named Matz. When he was creating Ruby, ",
         "Matz specifically wanted to make it a pleasant languages for people ",
         "as well as for computers. I think he did a pretty solid job!"
    para "Ruby is a very versatile language. You can make any kind of program ",
         "that you can imagine, and several that you can't! People make lots ",
         "of different things with it, including web sites, games, and tons of ",
         "fun things! In fact, Hackety Hack itself is written using Ruby!"
  end

  page "Your first program" do flow do
    para "Let's start with a very simple program.\n"
    para "Click on the "
    image "#{HH::STATIC}/tab-new.png", :margin => 6
    para "icon in the tab bar on the left to begin."
    next_when :tab_opened, :Editor
  end end

  page "Asking" do
    para "In the large box, type the following code exactly as written:"
    embed_code "# Asking and saying\n" +
      'name = ask("Your name please?")' + "\n" +
      "puts(name)"
    para "Click ", em("Run"), " when you're finished."
    next_when :program_run, :code => /\Wask\W.*\Wputs\W/
  end

  page "Okay, what happened?" do
    para "Congrats! See, that was a peice of cake!"
    para "Now, take a moment to look at the program. See if you can figure ",
      "out how it works.  What do you suppose the ", code("ask"),
      " command does? And what is that ", code("name"), " word for?"
    para "Now ", em("Save"), " the program.  Call it ", em("Asking"), ". "
    next_when :save, :any
  end

  page "Let's Hang on to This" do
    flow do
      para "Now click on the ", em("Home"), " icon ( "
      image "#{HH::STATIC}/tab-home.png", :margin => 6
      para ") in the tab bar."
    next_when :tab_opened, :Home
    end
  end

  page "Your Saved Programs" do
    para "Notice that the program is listed under ", em("Programs"),
      " You should see the name ", em("Asking"), ". Well done!"
  end

  page "A Note About Saving" do
    para "In the first line of your program, you placed a short comment. ",
      "Comments start with the number sign.  That criss-cross ",
      "chex mix thing.  Comments are ignored by Ruby."
    para "However, Hackety Hack will check the beginning of your program for a",
      " comment.  If one is found, it will be used as the description. "
  end

  page "How Asking Works" do
    para "The ", code("ask"), " command you used pops up a window ",
      "and lets the person at the computer type something in.  Whatever they ",
      "end up typing is handed back to your program.  You stored ",
      "the typing in the ", code("name"), " variable."

    para "So how does Ruby know that ", code("ask"), " is a command and ",
      code("name"), " is a variable?  Because of their position in the ",
      '"sentences" of your code.  For example, variables are created with ',
      "an equals sign. Since ", code("name"), " comes before the equals ",
      "sign, it is a variable."

      embed_code 'name = ask("Your name please?")'

      para "Part of coding is simply just spotting the order of things."

      para strong("EXTRA CREDIT"), ": Try changing the question to something ",
        "a bit meaner. Make your program all crabby."
  end
  
  page "A small note about order" do
    para "If you've paid close attention, you'll have noticed that the code ",
         "works in order, top to bottom! It's sort of like a to-do list."
    para "This is pretty similar to English. You have to start somewhere! ",
         "And just like English, programming languages also have grammar and ",
         "syntax rules that govern where commands, variables, and other things ",
         "go. We're not going to study those rules directly, we'll just pick ",
         "them up as we go. But if you loved English class, you could learn ",
         "those things if you'd like."
    para "However, we don't think about nouns and verbs when we talk in English, ",
         "and so don't over-think it! You'll pick it up pretty easily, as we go along."
  end

  page "Saying" do
    para "Now we're going to do something else with that name."

    para "Here's the new program (the first 2 lines are the same):"
    embed_code "# Asking and saying\n" +
      'name = ask("Your name please?")' + "\n" +
      'puts("Your name is #{name.length()} letters long")'

    para "Type this one in carefully. You'll notice in the quotes that there ",
      "is a little number sign and some curly braces.  The curly braces are ",
      "right above your square bracket keys (on a US keyboard)."

    para "Click ", em("Save"), " to save what you've done so far.  Then, ",
    em("Run.")
  end

  page "What's it Good For?" do
    para "The ", code("puts"), " command is nice, because you can tell the ",
      "person at the computer what's going on or just tell him somehting. ",
      "You can ",
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
      "  puts(\"Holding up \#{x} fingers\")\n" +
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

  page "What Went Wrong?" do
    para "Info about error messages can be show by pressing ", em("Shift + /"),
      ". So if you think or know something went wrong, like now, ",
      "you can give it a try."
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

    para "That's pretty good, actually.  Take a rest, enjoy your accolades ",
      " and let your brain soak in what you've got so far."

    # TODO: add an EXTRA CREDIT?
  end


  lesson "Getting Outdoors"

  page "What now?" do
    para "In Lesson One, we asked some things and we said somethings.  Not bad, ",
      "not bad.  But not incredibly useful, you know?  How about this: let's",
      " make the computer do something."

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
    para "A small note! Sometimes, the .rb isn't displayed. This depends on ",
         "the settings on your specific computer!"

    para "Now, check the ", strong("Downloads"), " folder.  Well, well, well. "
    "Fancy that. "
  end

  page "The Web Library" do
    para "To download the MP3, we use the ", code("Web.download"), " command. ",
      "This is just another command like ", code("ask"), " and ", code("puts"),
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
      'url = "http://xml.metafilter.com/rss.xml"' + "\n" +
      'Web.fetch(url) do |feed|' + "\n" +
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
      'url = "http://xml.metafilter.com/rss.xml"' + "\n" +
      'Web.fetch(url) do |feed|' + "\n" +
      "  feed.items().reject!() do |item|\n" +
      "    item.description().length() > 200\n" +
      "  end\n" +
      "  puts( feed.items() )\n" +
      "end"
  end

  page "Ahh! Complicated!" do
    para "Okay, let's step through this program.  It's quite a bit more ",
      "complicated, isn't it?  But it's only seven lines, so I think we can ",
      "figure it out."

    para "The Metafilter news gets saved in a variable called ", code("feed"),
      ". So we can play with it.  In line 4, the ", code("reject!"),
      " command is used. This command deletes things from a list. ",
      "And the news feed contains a list of news ", code("items"),
      ". Hmmm.  How does this all fit together?"

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
      'url = "http://xml.metafilter.com/rss.xml"' + "\n" +
      "Web.fetch(url) do |feed|\n" +
      "  feed.items().reject!() do |item|\n" +
      "    item.description().length() > 500\n" +
      "  end\n" +
      "  puts( feed.items() )\n" +
      "end"

    para "This program will remove any thing from the list which is longer ",
      "than 500 letters.  We just want to focus on the short little ",
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

  page "Methods again" do
    para "There is one more thing that you should know about methods: ",
      "you can leave out the parenthesis if you want, they are there just ",
      "to more easily see what the methods are. But you can also write:"

    embed_code "# Read the Metafilter feed.\n" +
      'url = "http://xml.metafilter.com/rss.xml"' + "\n" +
      "Web.fetch url do |feed|\n" +
      "  feed.items.reject! do |item|\n" +
      "    item.description.length > 500\n" +
      "  end\n" +
      "  puts feed.items \n" +
      "end"

    para "It works just the same!"
  end

  page "About the Do and End" do
    embed_code  "  feed.items().reject!() do |item|\n" +
      "    item.description().length() > 500\n" +
      "  end"
    para "We're going to skip getting too detailed on the ", code("do ... end"),
      " part, except to say: it checks to find blog entries longer than 500 ",
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

    para "Very, very good.  I do say.  Take a break, eat a gigantic Dagwood ",
      "sandwich, and please return when you are duly refreshed."
  end


  
  lesson "Secret Agent"

  page "Something Interesting" do
    para "So, you're still trying to get comfortable with Ruby, but we've ",
      "seen a lot more of what Hackety Hack can do.  Downloading and eating ",
      "blogs, not bad."

    para "But this lesson's going to hopscotch all that other stuff.  In this ",
      "lesson, you'll learn to create a program that let you encrypt and ",
      "decrypt messages!! ",
      "And we'll start to figure out what all the little pieces are: ",
      "strings, numbers, blocks.  Stuff like that."
  end

  page "window" do
    para "Start up another new program.  Save this one as ", 
      strong("Secret Agent"), ":"

    embed_code "# Encrypting messages\n" +
      "window do\n" +
      "  stack do\n" +
      '    title "Cypher"' + "\n" +
      '    para "My Secret Agent application"' + "\n" +
      "  end\n" +
      "end"

    para em("Save"), " it ", "and ", em("Run"), " it."

    para "We're using a few things we've seen before, but let's go over each ",
      "of them, to be clear."

    para "We've talked about commands (also called ", strong("methods"),
      ".)  What are the methods in the code? "
  end

  page "Let's See If You Were Right" do
    para "There are four methods in all: ", code("window"), ", ", code("stack"),
      ", ", code("title"), " and ", code("para"), "."
    
    para code("window"), " opens a new window, while ", code("stack"), " creates a ",
      "box with it's content stacked into a pile. Try removing ",
      code("stack do"), " and its matching " , code("end"),
      " to see the difference."

    para "The ", code("para"), ' method means "paragraph" here.'
  end

  page "Blocks" do
    para "Attached to ", code("window"), " is a block."

    embed_code "window do\n" +
      "  ...\n" +
      "end\n"

    para "The block is everything between ", code("do"), " and ", code("end"),
      ".  A block is a group of code attached to a command. Again: a ",
      strong("group of code"), " attached to a method."

    para "A block is like ", strong("a new lung"), ". You plug it in to make a ",
      "method breathe.  The ", code("window"), " method gives its block one ",
      "puff of air. And the block uses that puff of air to make all the parts ",
      "that go inside the window.  One window, made in one puff of air."
  end

  page "Blocks (cont'd.)" do
    para "We used a block a few other times.  Here's one:"

    embed_code(
      "1.upto(6) do |x|\n" +
      "  puts(\"Holding up \#{x} fingers\")\n" +
      "end")

    para "In this one, the block gets ", strong("six puffs of air"),
      " from the method ", code("upto"), ". Every time we count a new number, ",
      "the block gets a puff. And it uses that puff to say something and ",
        "take a short nap."

    para "Puff.  Puff.  Puff.  Puff.  Puff.  Puff!  And after that sixth one, ",
      "that block's life is over and done."
  end

  page "So, Is It Totally Disassembled?" do
    para "Okay, so we've almost finished taking this apart:"

    embed_code "# Encrypting messages\n" +
      "window do\n" +
      "  stack do\n" +
      '    title "Cypher"' + "\n" +
      '    para "My Secret Agent application"' + "\n" +
      "  end\n" +
      "end"
    
    para "First, we have the ", code("window"), " method, which ",
      "is attached to a block, an iron lung that gets turned on and handed ",
      "a puff of air.  In the block, the ", code("stack"), " command runs ",
      "and in turn hands a puff of air to another block containing the ",
      "code that displays the title and the paragraph."
  end

  page "Words in Strings" do
    para "Let's talk about the quoted phrases."
    embed_code '"My Secret Agent application"'

    para "This is a string.  It's a short string of letters.  When you think ",
      '"string", just imagine each letter is ',
      strong("clipped to a clothesline"), ". The little quotes are the clips ",
      "on each end, hooked on to the clothesline."
  end

  page "Upsy Reversy" do
    para "Strings are great for messing with words.  Try changing the third ",
      "line to:"
    embed_code 'title  "Cypher".upcase().reverse()'

    para "And run it. And think about that."

    para "What is ", code("title"), "? And what are ", code("upcase"),
      " and ", code("reverse"), "??"
  end

  page "Button" do
    para "Let's change the insides of the window a bit."

    embed_code "# Encrypting messages\n" +
      "window do\n" +
      "  stack do\n" +
      '    title "Cypher"' + "\n" +
      '    edit_box "put your text here"' + "\n" +
      '    button "Encrypt/Decrypt"' + "\n" +
      "  end\n" +
      "end"

    para em("Run"), " it."
    para "Hey neat! Try writing some text and clicking on the button. Did it ",
      "work?"
  end

  page "Well, Not Really" do
    para "Hmm.  Actually.  That didn't do anything.  That is unacceptable!"

    para  "Let's change the line defining the button, giving it a block:"

    embed_code '    button "Encrypt/Decript" do' + "\n" +
      '      puts "the button got pressed!"' + "\n" +
      '    end'

    para "That tells Hackety Hack to attach the button to the ",
     "block that contains the ", code("puts")," command. Try running it again ",
     "and press the button a few times. Watch the output on the Hackety ",
     "Hack window. So what happens? Every time the button gets presset it ",
     "gives a puff of air to the block and its code get executed."
  end

  page "ROT 13" do
    embed_code "# Encrypting messages\n" +
      "window do\n" +
      "  stack do\n" +
      '    title "Cypher"' + "\n" +
      '    box = edit_box "put your text here"' + "\n" +
      '    button "Encrypt/Decript" do' + "\n" +
      '      txt = box.text' + "\n" +
      '      box.text = txt.rot13' + "\n" +
      "    end\n" +
      "  end\n" +
      "end"

    para "The edit box is stored in a variable named ", code("box"),
      ". Its content can then be accessed with ", code("box.text"),
      ", while content of the box is changed with ", code("box.text ="), "."

    para "In Hackety Hack strings have the method ", code("rot13"),
      " that can be used to encrypt and decrypt their content."

    para strong("ROT 13"), ' means "rotate by 13 places" and is a simple ',
      "encryption method where each letter is replaced by the letter 13 ",
      "positions beyond it in the alphabet (when you reach the Z you ",
      "to continue with the A). So A becomes N, B becomes O, and so on... ",
      "Because there are 26 letters in the English language, you'll ",
      "get the original text back."
  end

  page "Lesson Three is In The Bag" do
    para "Wonderful, you've made a very simple program that helps you ",
    "encrypt messages. But look at all you learned:"
    
    item "You used ", strong(code("window")), " to make a little application ",
      "with its own window."
    item "Methods like ", code("edit_box"), " and ", code("button"),
      " were used to add content to the window."
    item strong("Strings"), " are letters inside quotes.  (Clipped to a ",
      "clothesline.)"
    item strong("Blocks"), " are like lungs, they can get one or more puffs ",
      "of air from the method they are attached to."

    para "For now, have a rest.  The next lesson will be short, but you ",
      "deserve a break after making your own super Secret Agent program."
  end

  

  lesson "The Ruby Language"

  page "Cheating" do
    para "You've done some useful things.  Downloaded files, built a simple ",
      "encryption application.  But let's stop and figure out how to ",
      "speed up your learning."

    flow do
      para "In the tab bar of Hackety Hack, you'll see a series of little ",
        "icons: a little house, a lightbulb.  Click on the "
      image "#{HH::STATIC}/tab-cheat.png", :margin => 6
      para "icon. This icon brings up the Cheat Sheet."
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
        "and you don't need to save anything, you can use the ",
        strong("Try Ruby"), " tab. To open it click on the "
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



  page "More help" do
    flow do
      para "Hackety Hack is based on a library called Shoes. It is Shoes ",
        "that contains methods like ", code("window"), " and ", code("button"),
        ". You can browse the Shoes help by clicking on "
      image "#{HH::STATIC}/tab-help.png", :margin => 6
      para ". The search option it contains is very useful."
    end
    para "Instead things like strings and arrays are built into Ruby itself. ",
      "You can easily find more information and help about Ruby by simply ",
      "searching with Google."
  end


  lesson "Turtle"

  page "Starting the Turtle" do
    para "In Hackety Hack you can control a ", strong("turtle"),
      " that will make nice drawings for you."

    embed_code "Turtle.start do\n" +
        "  forward\n  turnleft\n"*4 +
      "end"

    para code("Turtle.start"), " will tell the Turtle to start drawing. ",
      "It will draw using the commands inside the block."

    para "The nice thing about the Turtle is that you can make him move one ",
      "command at a time, this way it will be more easy to understand exactly ",
      "what happens, and to find mistakes in the code (sometimes called bugs)."

    para "If you run the code, a window will open. That window is the ",
      "playground of the turtle. There you can execute a single command at a ",
      "time, or, if you prefer, execute the whole code ad any speed you like. ",
      "Play a little with the buttons to understand how they work. If you ",
      "wrote the code correctly the turtle should be drawing a square."
  end

  page "Turtle is growing" do
    para "Think the square is too small? You might want to make it a little ",
      "bigger:"

    embed_code "Turtle.start do\n" +
        "  forward 200\n  turnleft\n"*4 +
      "end"

    para "I'll admit: it's still not much of a drawing. But what I really ",
      "wanted to show you is something else. To make only one change (making ",
      "the square bigger) you had to change the code in ", em("four"),
      " places."

    para "You should never be doing repetitive things like this when using a ",
      "computer. As a programmer you always want the computer to do the ",
      "boring stuff for you. Computers have been ", em("made"), " to do ",
      "boring and repetitive tasks in the place of humans."

    para "Whenever you find yourself doing something boring on the computer, ",
      "you probably are doing something wrong."
  end


  page "Be Lazy!" do
    para "You could write the following instead:"

    embed_code "Turtle.start do\n" +
      "  4.times do\n" +
      "    forward 200\n" +
      "    turnleft\n" +
      "  end\n" +
      "end"

    para "Looks much better right?"

    para "Methods like ", code("times"), " that have a block which gets called ",
      "multiple times are called ", strong("loops"), "."
  end

  page "Really Lazy" do

    para "If you still aren't convinced, try writing the following program without a ",
      "loop"

      embed_code "Turtle.start do\n" +
        "  36.times do\n" +
        "    forward\n" +
        "    turnleft 170\n" +
        "  end\n" +
        "end"

    para "Sometimes it isn't even possible to not use a loop, here is an ",
      "example:"

    embed_code "Turtle.start do\n" +
        "  # to_i changes to integer (a number)\n" +
        "  n = ask(\"how many times?\").to_i\n" +
        "  n.times do\n" +
        "    forward\n" +
        "    turnleft 172\n" +
        "  end\n" +
        "end"

    para "In this case you cannot know in advance how many times the loop will be run."
  end

  page "What now?" do

    para "Sometimes loops will not be enough to avoid code duplication. ",
      "The following code draws two squares."

    embed_code "Turtle.start do\n" +
        "  goto 120, 120\n" +
        "  4.times do\n" +
        "    forward\n" +
        "    turnleft\n" +
        "  end\n" +
        "  goto 480, 480\n" +
        "  4.times do\n" +
        "    forward\n" +
        "    turnleft\n" +
        "  end\n" +
        "end"

    para "We used a new method: ", code("goto"), ". With ", code("goto"),
      " you can make the turtle go to any position you want. He will not draw ",
      "anything while moving. The method takes two parameters, the first is ",
      "the distance of the turtle from the left, while the second is the ",
      "distance from the top. As an exercise try drawing the squares in the other ",
      "two corners instead."
  end

  page "Our Newborn Method" do
    para "There are many ways to avoid writing the same code twice. ",
      "We will now explore just one more."

    para "We need to avoid having to write the code for the square twice. ",
      "We do this by creating a method of our own."

    embed_code "def square\n" +
        "  4.times do\n" +
        "    forward\n" +
        "    turnleft\n" +
        "  end\n" +
        "end\n" +
        "\n" +
        "Turtle.start do\n" +
        "  goto 120, 120\n" +
        "  square\n" +
        "  goto 480, 480\n" +
        "  square\n" +
        "end"

    para "To create a method the ", code("def"), " keyword is used. ",
      code("def"), " means ", strong("define"), "."
  end

  page "The Method is Hungry" do
    para "We can add a parameter to the method. ", "This means giving the ",
      "method something to eat. This \"food\" will then be stored in a ",
      "variable. In the example below the variable has been called ", 
      code("size")

    embed_code "def square(size)\n" +
        "  4.times do\n" +
        "    # the size of the square will\n" +
        "    # depend on the parameter\n" +
        "    forward size\n" +
        "    turnleft\n" +
        "  end\n" +
        "end\n" +
        "\n" +
        "Turtle.start do\n" +
        "  goto 220, 220\n" +
        "  # big square\n" +
        "  square(200)\n" +
        "  goto 480, 480\n" +
        "  # smaller square\n" +
        "  square(100)\n" +
        "end"

    para "We now can use the same method to draw squares of different sizes. ",
      "Unfortunately this still doesn't look too much like art. We really ",
      "need to do something about this."
  end

  page "Cubism" do
   embed_code "def square(size)\n" +
        "  4.times do\n" +
        "    forward size\n" +
        "    turnleft\n" +
        "  end\n" +
        "end\n" +
        "\n" +
        "Turtle.start do\n" +
        "  50.times do\n" +
        "    goto rand(500), rand(500)\n" +
        "    square rand(100)\n" +
        "  end\n" +
        "end"

    para "Here we used the ", code("rand"), " method, which we haven't seen ",
      "yet. ", code("rand"), " means ", strong("random"), ". Calling this method is like ",
      "throwing a die. We use its parameter to tell ", code("rand"), " how ",
      "many faces the die has. Computers start counting by 0 so if we say the ",
      "die has 6 faces, it will be numbered from 0 to 5. Try running the ",
      "following code in the try ruby console:"

      embed_code "30.times{print rand(6)}"

      next_when :try_ruby_command,
        :code => /rand/, :answer => Numeric, :output => /[0-5]{5,}/
  end

  page "Ready to Draw" do
    para "Okay."
    para "You are now ready to try writing you own paintings! The ",
      "turtle has many other methods you can use."
  end


  lesson "The End"

  page "Game Over, Roll Credits" do
    para "You did so AWESOME!!"

    para "So, where to now?  Well, you might try to go to the Hackety Hack ",
      "website, or look at the samples displayed in the home tab. Or just ",
      "try experimenting.  You've got help pages.  And you know where the ",
      "cheat sheet is.  Hack away!"
  end
end
