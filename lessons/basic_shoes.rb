# encoding: UTF-8

lesson_set "4: Basic Shoes" do

  lesson "Hello there!"
  page "Let's get started" do
    para "Welcome to your first lesson about Shoes! I'm going to introduce you to the ",
         "basics that Shoes brings to everyone who programs."
    para "If you didn't know, Shoes is a Ruby toolkit that lets you build GUI programs ",
         "really easy and fun!"
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

  lesson "Apps"
  page "Shoes.app" do
    para "Okay! Shoes is tons of fun. It's really easy to get started. Here's the ",
         "simplest Shoes app ever:"
    embed_code "Shoes.app do
end"
    para "Give that a spin!"
  end

  page "It's just a block" do
    para "You didn't say that you wanted anything in the app, so it just gives you ",
         "a blank window. You can pass options in, too: "
    embed_code "Shoes.app :height => 200, :width => 200 do
end"
    para "This'll give you whatever sized app you want! We'll be putting all of the ",
         "fun stuff inside of the ", code("do...end"), "."
  end

  lesson "para"
  page "The basics" do
    para "Blank windows are pretty boring, so let's spice it up with some text!"
    embed_code 'Shoes.app do
  para "Hello, world"
end'
    para "You know what to do by now. ", code("para"), " is short for 'paragraph.' It ",
         "lets you place text in your apps."
    para code("para"), " and other Shoes widgets take bunches of options, too. Check ",
         "it:"
    embed_code 'Shoes.app do
  para "Hello there, world", :font => "TakaoGothic"
end'
  end

  lesson "stacks"
  page "They're default!" do
    para "If you're looking to lay out your Shoes widgets, there are two options. The ",
         "first is a ", code("stack"), ". A Stack is the default layout a Shoes app ",
         "has. So this won't look much differently than one without the stack:"
    embed_code 'Shoes.app do
  stack do
    para "Hello!"
    para "Hello!"
    para "Hello!"
  end
end'
    para "As you can see, the ", code("para"), "s are stacked on top of each other. ",
         "By itself, kinda boring, since they already do this. But..."
  end

  lesson "flows"
  page "The counterpart of stacks" do
    para code("flow"), "s are kind of like stacks, but they go sideways rather than ",
         "up and down. Try this as an example:"
    embed_code 'Shoes.app do
  flow do
    para "Hello!"
    para "Hello!"
    para "Hello!"
  end
end'
    para "Just a little bit different, eh?"
  end

  lesson "stacks + flows"
  page "With their powers combined..." do
    para "You can combine the ", code("stack"), " with the ", code("flow"), "s ",
         "to make whatever kind of layout you want. For example: "
    embed_code 'Shoes.app do
 flow do
    stack :width => "50" do
      para "Hello!"
      para "Hello!"
      para "Hello!"
    end
    stack :width => "50" do
      para "Goodbye!"
      para "Goodbye!"
      para "Goodbye!"
    end
  end
end'
    para "The ", code(":width"), " attribute sets how wide the stack is. Pretty simple."
  end

  lesson "button"
  page "Push it real good" do
    para "Buttons are also super simple in Shoes. Just give them a title and a ",
         "bunch of code to run when they get pushed:"
    embed_code 'Shoes.app do
  button "Push me" do
    alert "Good job."
  end
end'
    para "I bet you're starting to see a pattern. Shoes loves to use blocks of code ",
         "to make things super simple."
  end

  lesson "image"
  page "Pics or it didn't happen" do
    para "There are two ways that you can show an image in a Shoes app. Either you ",
         "have the file on your computer:"
    embed_code 'Shoes.app do
  image "#{HH::STATIC}/matz.jpg"
end'
    para "(Can you figure out what this does? Don't feel bad if you can't.)"
    para "You can also specify an image on the web:"
    embed_code 'Shoes.app do
  image "http://shoesrb.com/images/shoes-icon.png"
end'
    para "Either one is fine. Shoes cares not."
  end

  lesson "edit_line"
  page "Getting some input" do
    para "If you'd like to let someone type something in a box, well, ", 
         code("edit_line"), " is right up your alley!"
    embed_code 'Shoes.app do
  edit_line
end'
    para "This is sort of boring though... why not get the information from the box?"
    embed_code 'Shoes.app do
  line = edit_line
  button "Push me!" do
    alert line.text
  end
end'

  end

  lesson "Summary"
  page "Great job!" do
    para "There's a ton more things that you can do with Shoes, but you've got the ",
         "basics down!"
    para "If you'd like to learn more, you can visit the ", 
          link("Shoes website", 
               :click => "http://shoesrb.com/"),
         " or press Control-M (or Command-M) to bring up the Shoes Manual."
  end

end
