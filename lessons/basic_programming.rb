lesson_set "2: Basic Programming" do

  lesson "Hello there!"
  page "Round One" do
    para "So, you'd like to learn how to hack code with the best of 'em, eh? Well, ",
      "you've come to the right place. This is the very first lesson I have to ",
      "share with you. It all starts here."
    para "I want to get you started off on the best possible foot with making ",
      "programs, so we'll start off by talking a little bit about what ",
      "programming is, and then we'll write some basic programs to draw fun ",
      "things on the screen. Sound good? Off we go!"
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

  lesson "Let's talk about programming"
  page "It's all about instructions" do
    para "When you get down to it, programming is all about ", strong("algorithms"),
      ". That's a big fancy word for 'a list of instructions.' Every program ",
      "is simply a big to-do list of instructions for the computer to follow."
    para "You can turn almost anything into a list of instructions if you really ",
      "think about it. Most of the time, you've got so much practice at doing ",
      "things that you don't even think about these individual steps. You just ",
      "do them. It's very natural."
  end

  page "The computer is simple" do
    para "Unfortunately, computers are actually quite simple. This may be contrary ",
      "to everything you've ever heard, but it's the truth. Even though we ",
      "compare computers to things like our brains, it's a really poor analogy. ",
      "What computers are actually really good at is performing simple, boring ",
      "things over and over again very accurately. They can't think for ",
      "themselves!"
    para "This is why computers appear to be complex. They blindly follow whatever ",
      "orders they're given, without any thought about how those instructions ",
      "are good or bad. It's hard to think in such simple terms!"
  end

  page "Explain yourself well" do
    para "It's important to remember that you have to fully explain yourself to the ",
      "computer when you're programming. It can't figure out what you're trying ",
      "to say, so you have to say what you mean!"
    para "This takes some practice, so we're going to start off with some exercises ",
      "in explaining ourselves in very basic terms. It's almost like trying to ",
      "explain math to a young child: you have to go slowly, triple check your ",
      "work, and have some patience when it just doesn't quite get it."
  end

  lesson "Lists of Instructions"
  page "A to-do list, not a shopping list" do
    para "When I say that computers follow lists of instructions, I mean a to-do ",
      "list, not a shopping list. What I'm trying to say is that these lists have ",
      "an ", strong("order"), " to them that the computer follows. It does each ",
      "step in turn as quickly as it possibly can."
    para "A shopping list is a different kind of list entirely. You can go to ",
      "whichever aisle you choose, and as long as you get everything before you ",
      "leave, you're A-OK. This isn't what the computer does at all."
  end

  page "How would you tell a person to do it?" do
    para "Let's try an example: if you had to tell someone in words how to draw a ",
      "square on a piece of paper, how would you do it?"
    para "You're not allowed to say \"like this\" or \"this way,\" that's cheating! ",
      "You have to spell out every detail."
  end

  page "Once again: computers are simple" do
    para "How'd you do? I can't see what you said, but here's an example of how ",
      "simple computers are compared to people. Did you forget to mention how long ",
      "each side of the square is? If you didn't good job!"
    para "Here's how I'd do it, by the way. This isn't the only right answer, it's ",
      "just an example:"
    para "1. Put your pen down on the paper."
    para "2. Draw right one inch."
    para "3. Draw down one inch."
    para "4. Draw left one inch."
    para "5. Draw up one inch."
    para "6. Take your pen off of the paper."
    para "7. You're done!"
  end

  lesson "Turtles, all the way down."
  page "Drawing... with turtles?" do
    para "Okay! Enough of these thinking experiments. Let's actually make something. ",
      "I bet you've been wondering when that was going to start, right? It's ",
      "really important to get the basics down first."
    para "We're going to tell the computer how to draw shapes... with turtles. Yes, ",
      "you heard me right. You're going to have to give these instructions to a ",
      "turtle."
    para "This particular turtle is carrying a pen. You have a piece of paper. The ",
      "turtle will follow your every word. But the turtle is a bit slow, and ",
      "needs careful instruction. Are you up to it?"
  end

  page "The Turtle and its commands" do
    para "We have to tell Hackety Hack that we want to tell the Turtle what to do. ",
      "To do that, we have a ", code("Turtle"), " command. We can tell the ",
      code("Turtle"), " two things: "
    para code("draw"), ": the turtle will follow our instructions at lightning speed, "
    "drawing our entire image in the blink of an eye."
    para code("start"), ": an interactive window will appear, which lets you see ",
      "the turtle move at each step in the program. You can move at your own ",
      "pace. This is useful if the turtle isn't doing what you expect!"
    para ""
    flow do
      para "Click on the editor tab ("
      image "#{HH::STATIC}/tab-new.png", :margin => 6 do
        alert("Not this one, silly! the one on the left!")
      end
      para ") to get started."
    end

    next_when :tab_opened, :Editor
  end

  page "Type it in!" do
    para "Cool. Now type this: "
    embed_code "Turtle.draw"
    para "The period in between the ", code("Turtle"), " and the ", code("draw"), 
         " connects them together. Programming languages have rules, just like ",
         "English has rules! You can think of ", code("Turtle"), " like a subject, ",
         "and ", code("draw"), " as a verb. Together, they make a sentence: hey ",
         "turtle, draw me something!"
    para "Once you've typed that in, go ahead and click the 'Run' button. The turtle ",
         "moves so quickly in ", code("draw"), " mode that you won't even see him, ",
         "but I assure you, he's there!"
  end

  page "Do... what I tell you to" do
    para "Awesome! We've got the turtle going, at least. Now we need to tell ",
         "it what we want to draw!"
    para "Remember when we said that all programs are lists of instructions? In this ",
         "case, our program only has one instruction: ", code("Turtle"), ", draw ",
         "something! But we need to be able to give the ", code("Turtle"), " its ",
         "own list of instructions."
    para "To do this, we'll use two words: ", code("do"), " and ", code("end"), ". ",
         "These two words together make up a ", em("sublist"), " of things, just for ",
         "the ", code("Turtle"), "!"
  end

  page "Changing the background" do
    para "Let's try this: we can tell the ", code("Turtle"), " that we want to use ",
         "a different background color by using the ", code('background'), " command. ",
         "Check it out:"
    embed_code "Turtle.draw do
  background maroon
end"
    para "Type this in and click 'Run'!"
  end

  page "The Turtle gets its orders" do
    para "Cool stuff! The background is now maroon. You can find a full list of ",
         "colors that are supported on the ", link("Shoes website", :click => 'http://shoesrb.com/manual/Colors.html'), "."
    para "This is also how you make lists of instructions for the ", code("Turtle"), 
         " to follow. To make it a little easier to see, programmers will often ",
         "put two spaces before sublists. Get in the habit now, you'll thank me later!"
  end

  page "The pen" do
    para "Now that we've got a snazzy background color, how do we draw some lines? ",
         "Well, the first thing you need to know about is the pen. The ", 
         code("Turtle"), " carries a pen along, and drags it along the ground behind ",
         "itself. You can change the color of line the pen draws with the ",
         code("pencolor"), " command."
  end

  lesson "Drawing lines"
  page "Sally forth!" do
    para "Okay, enough dilly-dallying. Let's tell the turtle to draw a line! Here's ",
         "my line. Give this one a shot, then try your own colors and numbers!"
    embed_code "Turtle.draw do
  background lightslategray
  pencolor honeydew
  forward 50
end"
    para "50 is the number of pixels to move foward, by the way."
  end

  page "You spin me right round, baby" do
    para "Great! So you've got a line. But what if you don't want the ", 
         code("Turtle"), " to move forward? Well, you can tell it to turn by using a ",
         code("turnleft"), " or ", code("turnright"), " command, like this:"
    embed_code "Turtle.draw do
  background lightslategray
  pencolor honeydew
  forward 50
  turnright 90
  forward 50
end"
   para "Give that a shot, then play with it a bit!"
   para "If you're wondering what 90 means, it's the number of degrees that it'll turn."
  end

  page "I like to move it, move it" do
    para "Okay, now we're cooking! Let's break this down again:"
    para code("Turtle.draw"), " tells the ", code("Turtle"), " we want it to draw ",
         "some things. The period connects the two."
    para code("do ... end"), " is a sublist of things. This is what we want the ",
         code("Turtle"), " to be drawing. Not for the rest of our program."
    para code("pencolor"), " sets the color of the pen the ", code("Turtle"), " is ",
         "dragging along behind him, and ", code("background"), " sets the color of ",
         "the background."
    para code("turnright"), " (or its buddy ", code("turnleft"), ") tells the ",
         code("Turtle"), " to turn to the right or left."
    para code("forward"), " (or its friend ", code("backward"), ") tells the ",
         code("Turtle"), " to move."
  end

  page "Let's try drawing that square" do
    para "Go ahead. Give it a shot. Try to get the ", code("Turtle"), " to draw a ",
         "square."
    para "I'll wait. :)"
  end

  page "Here's my version" do
    para "Here's how I did it:"
    embed_code "Turtle.draw do
  background lightslategray
  pencolor honeydew
  forward 50
  turnright 90
  forward 50
  turnright 90
  forward 50
  turnright 90
  forward 50
end"
  end

  lesson "Repeating ourselves"
  page "Pete and Repeat..." do
    para "Man, that was a ton of reptition! My fingers almost fell off typing ",
         code("forward"), " and ", code("turnright"), " there!"
    para "I have good news, though: I mentioned something earlier about computers. ",
         "It turns out that doing boring, repetitive things is something they're ",
         "really good at! They'll do the same thing over and over again, forever even ",
         "as long as you ask nicely."
  end

  page "Repeating repeating ourselves ourselves" do
    para "Check it out: our ", code("Turtle"), " actually knows numbers. For ",
         "example:"
    embed_code "Turtle.draw do
  background lightslategray
  pencolor honeydew
  4.times do
    forward 50
    turnright 90
  end
end"
    para "Try running this example. It also draws a square! Wow!"
  end

  page "4.times" do
    para "It's pretty easy: ", code("4"), " can take instructions too, just like ",
         "our ", code("Turtle"), ". This command repeats a list of instructions ",
         "that many times. Fun! Four times. And the ", code("do"), " and ",
         code("end"), " show which list of instructions go with the ", code("4"),
         " rather than with the ", code("Turtle"), "."
  end

  page "Try it out!" do
    para "Have a blast: make some fun shapes of your own!"
  end

  lesson "Summary"
  page "Congratulations!" do
    para "Wow, you're awesome. Pat yourself on the back. High five someone. You've ",
         "got these basics down!"
    para "Check out the ", em("Basic Ruby"), " lesson to pick up some totally ",
         "different and exciting things!"
  end

end
