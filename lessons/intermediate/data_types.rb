# encoding: UTF-8

lesson_set "Data Types" do

  lesson "This is where it starts getting fun!"
  page "Let's get started" do
    para "Awesome! Glad to see you here! You're going to learn some great ",
         "things in this lesson. Ruby has a few different ways to manipulate ",
         "data, and you're going to play with them!"
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

  lesson "Strings"
  page "You've got this down!" do
    para em("String"), "s are something you already know about! Let's ",
         "refresh your memory."
    para "Basically, Strings let you manipulate a bunch of characters. It's ",
         "sort of like writing something down: and often, Strings are used ",
         "for handling input and output. Check it out:"
    embed_code 'name = "Steve"' + "\n" + 'alert name'
    para "This should be familliar. If it isn't you may want to go review ",
         "the Basic Ruby lesson before moving on. Gotta learn the basics ",
          "before you can understand the hard stuff!"
  end

  page "Concatawhat?" do
    para "Here's a big word for you: ", strong("concatenation"), ". It's a ",
         "mouthful, but luckily for you, it means something really simple: "
         "addition. Check this code out:"
    embed_code 'first_name = "Steve"' + "\n" +
               'last_name = "Klabnik"' + "\n" +
               'alert first_name + last_name'
    para "See what I mean by addition? The ", em("+"), " lets us ",
         strong("concatenate"), " the two Strings together. The first name ",
         "goes up front, and the last name goes in the back. Nice and easy."
  end

  page "Interpawho?" do
    para "Okay, since you did so well with that word, I'm going to throw ",
         "another one at you, while you're still trying to recover: ",
         strong("interpolation"), ". It kinda means 'put into.' See if this ",
         "makes sense:"
    embed_code 'first_name = "Steve"' + "\n" +
               'alert "The first name is #{first_name}".'
    para "Whoah! What's up with that? Try running it, and see what it does."
  end
  
  page "They're like pincers" do
    para "Terrible analogy alert: See that { and its partner in crime, }? ",
         "These two ", em("curly braces"), " are like the pincers of some ",
         "strange species of crab. You can put whatever you want between ",
         "them, and they hold your info in place in the middle of a string."
    para ""
    para "Oh, and the # (a ", em("hash"), "), is a funky hat the crab wears. ",
         "Or something. I dunno. Point is, you need all three parts, \#{} ",
         "and something in the middle. And that's ", strong("interpolation"),
         "."
  end

  lesson "Arrays"
  page "The 411" do
    para em("Ruby"), " was created by "
  end

  page "Concatination" do

  end

  page "A short shout-out to Modules" do

  end

  page "Not a treasure map..." do

  end

  page "Gotta collect 'em all!" do

  end

  lesson "Hashes"
  page "A slightly different Array" do
    para em("Ruby"), " was created by "
  end

  lesson "Putting them together"
  page "Arrays of Arrays" do

  end

  page "Arrays of hashes" do

  end

  page "Hashes of hashes" do

  end

  page "Hashes of Arrays" do

  end

  lesson "Summary"
  page "Good job!" do
    para "Awesome! You should be prepared to play around with all kinds of ",
         "data now. Keep up all the good work!"
  end

end
