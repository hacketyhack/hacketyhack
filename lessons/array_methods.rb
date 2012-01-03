lesson_set "Fun with Arrays" do

  lesson "Hello There!"
	  page "Let's get started" do
	    para "This lesson will give you a better handle on all the things you can"
	          "do with arrays.  "
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
	
	page "What's an array again?" do

		para "An array is like a dresser where each drawer has a number.",
		    "The number is called a key, and the thing inside the drawer is called,"
        "a value."

    para "You can save an array in a variable, like this:"

    embed_code 'my_array = [1,99,"shoes",doggy, ["apple"","pear"]]'

    para "Arrays can hold all kinds of data! You get the items out by calling an object's key."

	  embed_code 'alert my_array[0] returns 1, which is a number'
	  embed_code 'alert my_array[1] returns 2, which is also a number'
	  embed_code 'alert my_array[2] returns "shoes", which is a string'
	  embed_code 'alert my_array[3] returns doggy, which is a variable'
	  embed_code 'alert my_array[4] returns ["apple"","pear"], which is another array!'

    para "You can try typing in your own array and returning values until you get the hang of it."
  end
  
  page "Adding on to arrays" do

    para "One of the cool things about Ruby as a programming language is that it makes it",
          "really easy to work with arrays.  Try this out:"

  	embed_code 'zoo = ["lion","tiger"]'
  	embed_code 'alert zoo'

    para "We just made an array! Now lets say we want to put 'elephant' in the array.",
          "We've already learned we can put it in the third position by doing this:"

  	embed_code 'zoo[2] = "elephant"'
	
    para "But then we always have to know how many items are in the array. There's an",
          "easier way: we can 'push' the new item into the array.  Try it out:"

  	embed_code 'zoo.push("lemur")'
  	embed_code 'alert zoo'

    para "There's even a shorter way to write this:"

  	embed_code 'zoo << "gorilla"'
  end
end
