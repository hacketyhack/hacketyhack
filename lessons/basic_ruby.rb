# encoding: UTF-8

lesson_set "3: Basic Ruby" do

  lesson "Hello there!"
  page "Let's get started" do
    para "Welcome to your first lesson in Ruby! You're going to have a blast."
    para "Ruby is a great programming language that you can use to make all kinds of ",
         "things with. Let's get going!"
    flow do
      para "(click the little "
      icon_button :arrow_right, nil do
        alert "Not this one! The one below!"
      end
      para " on the bottom of the screen to get started)"
    end
  end

  page "Lesson Controls" do
    para "Before we move on, Here's a refresher on the controls you can use ",
      "to move around in the Lesson."
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
    para "to move to the next part. Have at it!"
  end

  lesson "A bit more about Ruby"
  page "Konnichiwa, Ruby!" do # can't do 日本語 without a bunch of work...
    flow do # due to multiple fonts...
      para em("Ruby"), " was created by "
      para "まつもと ゆきひろ", :font => "TakaoGothic"
      para " (you can just call him Matz) in 1995. If you couldn't guess, Matz is ",
           "from Japan. Here he is:"
    end
    image "#{HH::STATIC}/matz.jpg"
  end

  page "Ruby is enjoyable" do
    para "Matz has this to say about Ruby:\n"
    para em("I hope to see Ruby help every programmer in the world to be productive, and to enjoy programming, and to be happy. That is the primary purpose of Ruby language.\n")
    para "One more thing about Ruby: Rubyists (that's what people who like Ruby call ",
         "themselves) have a saying: ", strong("MINSWAN"), ". This stands for ", 
         strong("M"), "atz ", strong("I"), "s ", strong("N"), "ice ", 
         strong("S"), "o ", strong("W"), "e ", strong("A"), "re ", strong("N"), "ice. ",
         "Which is a pretty nice saying, itself. Be nice to everyone, and give them ",
         "a hand when they need it!"

  end

  lesson "Displaying Things"
  page "Let's do this!" do
    para "Okay! The very first thing that you need to know is how to show something ",
         "on the screen. Otherwise, you won't know what's going on!"
    flow do
      para "In order to start coding, we need to bring up the Editor. Click the ("
      image "#{HH::STATIC}/tab-new.png", :margin => 6 do
        alert("Not this one, silly! the one on the left!")
      end
      para ") to open it up."
    end
    next_when :tab_opened, :Editor
  end

  page "Hello, World!" do
    para "There are two ways of doing this. Here's the first: alert"
    embed_code 'alert "Hello, world!"'
    para "Type this in and press the 'Run' button."
  end

  page "alert" do
    para "Okay, let's break this down: There's two main parts to this little program: ",
         "you have an ", code("alert"), ", and a ", code('"Hello, world!"'), ". These ",
         "two parts work just like an English sentence: The ", code("alert"), " is a ",
         'verb and the stuff in the ""s is an object. In Ruby, we call verbs ',
         strong("methods"), ". The ", code("alert"), " verb says 'Put an alert box ",
         "on the screen, and the content of the box is whatever thing you give me.'"
    para "We'll talk about the ", code('"Hello, world!"'), " in just a second. Here's ",
         "the other way of making this happen: "
    embed_code 'puts "Hello, world!"'
    para "But if you try that here, it won't work! The ", code("puts"), " method ",
         "doesn't display a dialog box, it puts text out to a command-line prompt. ",
         "Since Hackety Hack is all graphical, this doesn't work here. So we'll ",
         "be using ", code("alert"), "s throughout these tutorials, but if you look ",
         "at other Ruby tutorials, you may see ", code("puts"), "."
  end

  lesson "Letters, words, and sentences"
  page "Strings" do
    para "Okay! Now that you've got that verb bit down, it's time to learn about ",
         em("String"), "s. Strings are what we call a bunch of words between a pair ",
         "of \" characters. The \"s are used to tell the computer what words you ",
         "actually want to say. Let's think about our example:"
    embed_code 'alert "Hello, world!"'
    para "If you didn't have the \"s, the computer wouldn't know which words were ",
         "methods and which ones were part of the string! And consider this:"
    embed_code 'alert "I am on high alert!"', :run_button => true
    para "Without making all of those words a string, how would Ruby know that the ",
         "second alert was some text you wanted to say, rather than another alert box?"
  end

  page "Adding Strings" do
    para "Now, if you want to put two bits of strings together, you can use the ",
         code("+"), " character to do it. Try typing this:"
    embed_code 'alert "Hello, " + "world!"'
    para "Same thing! The ", code("+"), " sticks the two strings together. This ",
         "will end up being super useful later!"
  end

  lesson "Numbers and Math"
  page "Numbers" do
    para "You can just use numbers, and Ruby understands them:"
    embed_code "alert 2"
    para "You can even use numbers that have a decimal point in them:"
    embed_code "alert 1.5"
  end

  page "Basic Math" do
    para "You can also do math with numbers, and it'll work out pretty well:"
    embed_code "alert 1 + 2"
    para ""
    embed_code "alert 5 - 3"
    para ""
    embed_code "alert 2 * 3"
    para ""
    embed_code "alert 4 / 2"
    para ""
    para "But if you try this, nothing happens:"
    embed_code 'alert "hey" + 2'
    para "This is kind of fun and silly, though:"
    embed_code 'alert "hey" * 2'
  end

  page "Errors" do
    para "You know how nothing happened when you hit the Run button earlier? That ",
         "was because there was an error. You can see any errors that run by hitting ",
         "either Alt-/ or Command-/, depending on what kind of computer you're using."
    para "The error that results from ", code('alert "hey" + 2'), " is "
    embed_code "can't convert Fixnum into String"
    para "What is that?"
  end

  lesson "A few words about types"
  page "Why's it do that?" do
    para "Each part of a Ruby program is an ", code("Object"), ". Right now, all you ",
         "need to know about ", code("Object"), "s is that it's sort of like saying ",
         '"a thing." Your program is made up of a bunch of ', code("Object"), "s ",
         "working together."
    para "We'll learn more about ", code("Object"), "s in a future lesson, but there ",
         "is one thing I'll tell you: ", code("Object"), "s have a 'type.' This lets ",
         "Ruby know what kind of ", code("Object"), " it is."
  end

  page "Adding numbers to words" do
    para "That's why"
    embed_code 'alert "hey" + 2'
    para 'doesn\'t really work: "hey" is a ', code("String"), " object, and 2 is a ",
         code("Fixnum"), " object. And adding ", code("String"), "s and ",
         code("Fixnum"), "s doesn't make any sense. We can make this code work, though!"
    para "All we need to do is turn the ", code("Fixnum"), " into a ", code("String"),
         ". We can do this by using the ", code("to_s"), " method."
    embed_code 'alert "hey" + 2.to_s'
  end

  page "Let's look at that again" do
    embed_code 'alert "hey" + 2.to_s'
    para "Okay, this isn't bad. We have our ", code("alert"), " method. We're giving it ",
         code('"hey" + 2.to_s'), ". The ", code("2.to_s"), " turns a ",
         code("Fixnum"), " 2, which is like the mathematical idea of a 2, into the ",
         code("String"), " 2, which is like when you write a 2 down on a piece of ",
         "paper."
  end

  lesson "Variables"
  page "They're like boxes" do
    para "What happens if we want to keep something around? Most programs are not ",
         "one line, I assure you. You can use a ", em("variable"), " to hold a ",
         "value and use it later. It's like a box that you put things in."
    para "Let's try one out:"
    embed_code 'message = "Hello, world!"
alert message'
    para "Give that a run."
  end
  page "Assignment" do
    para "Cool stuff! We used an ", code("="), " to ", em("assign"), " the ", code("String"), '"Hello, world!" into the variable ', code("message"), ". We then passed that ",
         code("message"), " to the ", code("alert"), " method."
    para "As you can see, we can use variables in place of another value. Try this:"
    embed_code 'number = 5
number = number * 2
number = number - 8
number = number + 1
alert number'
    para "Make a guess before you run this program."
  end

  lesson "User Input"
  page "ask-ing for it." do
    para "We can ask the user of our program for some input, and then put their answer ",
         "into a variable. It's easy! Check this program out:"
    embed_code 'name = ask "What is your name?"
alert "Hello, " + name'
    para "The ", code("ask"), " method brings up a box and lets our users type ",
         "something in. Fun! We put their answer into the ", code("name"), " variable ",
         "and then showed it with ", code("alert"), ". Sweet!"
  end

  lesson "Basic flow control"
  page "if..." do
    para "Remember back to that Beginning Programming lesson... we talked about how ",
         "programs are one big list, that the computer follows in order."
    para "Well, guess what? We can actually change this order by using certain bits ",
         "of code. Compare these two programs:"
    embed_code 'number = 2
if number == 2
  alert "Yes!"
else
  alert "No!"
end'
    embed_code 'number = 1
if number == 2
  alert "Yes!"
else
  alert "No!"
end'
    para "There are a few new things here."
  end

  page "==" do
    para "Here it is again:"
    embed_code 'number = 2
if number == 2
  alert "Yes!"
else
  alert "No!"
end'
    para "The == command is just a bit different than the = command. == tests the ",
         code("Object"), " on its right against the ", code("Object"), " on its left. ",
         "If the two are equal, then the code after the ", code("if"), " will run. ",
         "If they're not equal, you get the code after the ", code("else"), ". The ",
         code("end"), " lets us know we're done with our ", code("if"), "."
  end

  lesson "Example: a guessing game"
  page "Guess!" do
    para "Let's put this all together:"
    embed_code 'secret_number = 42.to_s
guess = ask "I have a secret number. Take a guess, see if you can figure it out!"
if guess == secret_number
  alert "Yes! You guessed right!"
else
  alert "Sorry, you\'ll have to try again."
end'
    para "Can you guess what ", code("to_s"), " does, and why you need it? If you're ",
         "stumped, try asking ", link("on the Hackety Hack site", 
                                      :click => "http://hackety-hack.com/stream"), " ",
         "and we'll give you a hand."
  end

  lesson "Summary"
  page "Good job!" do
    para "Congrats! You've picked up all of the basics of Ruby. There's a lot more ",
         "you still have to learn, though!"
    para "Here's what you've learned so far:"
    para "* ", code("alert"), " and ", code("ask")
    para "* ", code("="), ", variables, and ", code("==")
    para "* ", code("if"), " and ", code("else")
    para "Awesome! You'll want to check out Basic Shoes next!"
  end

end
