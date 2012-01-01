lesson_set "Beginner Data Structures" do

  lesson "Hello there!"
  page "Let's get started" do
    para "Welcome to your first lesson about Data Structures!  Now that you ",
         "know how to obtain data with Ruby you're also going to be able to store it in collections.  ",
         "Arrays and Hashes are two key classes in Ruby that are able to help with ",
         " storing your data!  Let's get going!"
      
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

  page "What are Arrays?" do
    para "An array can be thought of as a dresser where each drawer is a numbered spot.  This ",
         " dresser is a collection of slots where one thing can be in each place.  Arrays  are ",
         " used to store data like numbers, strings, or even other Arrays!  Ruby makes it really easy ",
         " to create and store things inside of them.  Let's get going!"
  end

  page "What can we do with them?" do 
    embed_code 'my_array = [1,2,"shoes"]'
    para "Try typing this and press the Run button."
    para "You created an array with the numbers 1, 2, and the string 'shoes' in it.  Things in the array can be ",
         "gotten by typing the array's variable name(my_array) and square brackets( [] ) with a number ",
         "inside of the brackets.  This number can be thought of as the address to that spot in the array.  ",
         "It's good to remember that arrays start at 0 in Ruby."
    embed_code 'alert a[0]'
    para "What thing in the array are you going to get back?  Type this in and press the 'Run' button."
  end

  page "Arrays in action!" do
    para "When using Arrays we need to know a few things first.  Arrays in Ruby",
         " can expand to the size that you need them.  So if you wanted to put the string",
         " 'cat' at spot 99(which would be the 100th item in the array) we could put: "
    embed_code 'my_array[99] = "cat"'
    para "If there is nothing in a spot you will have 'nil' filling it."  
    para "If we wanted to print out everything in an array we could do something like this: "
      embed_code 'my_new_array = ["cat","dog","mouse"]'
    para "Then we would put: "
    embed_code 'my_new_array.each {|animal| alert animal}'
    para "Type this all in and press the 'Run' button."
  end
  
  page "Arrays in even more action!" do
    para "We've seen what we can do with arrays, but what other things can they do to help us?",
    	 "  What if we had an array of numbers and we wanted to sort it?  Try typing this this and running it: "
    embed_code 'num_array = [4,3,22,19,100,45]'
	embed_code 'alert num_array.sort'
	para "That was really easy to sort it from lowest to highest!  What if we want it from highest to lowest though?",
	     "  Type this in next and press the 'Run' button."
	embed_code 'alert num_array.reverse'
	para "The array class has so many methods that you can call upon it.  ",
	     "Take a look on the Ruby API: http://www.ruby-doc.org/core/classes/Array.html"
  end
	
lesson "The Hash"
  page "What are Hashes?" do
    para "Now that we've gotten an introduction to Arrays we can also learn about Hashes!",
         "  Hashes in other languages are sometimes called Dictionaries.  Well, what do they do?", 
         "  Like in a dictionary you are able to look up a word or 'key' which corresponds to a 'value'.",
         "  You separate the key and value with a hashrocket (=>).  Just like Arrays you can access a certain key ",
         " by typing the hashes variable name and the key in square brackets ([]).  ",
         "  Let's try working with a hash!"
    embed_code 'my_hash = { "dog" => "puppy", "cat" => "kitten" }'
    embed_code 'alert my_hash["dog"]'
    para "Try typing this all in and press the 'Run' button!"
  end
  
  page "Working with Hashes" do 
    para "So what else are we able to do with hashes?  ",
         "Let's try something will help us see if something is in the hash as a key or value",
         "  The methods 'has_key?' and 'has_value?' are exactly what we're looking for!"
    embed_code 'new_hash = { "1" => "one", "2" => "two"}'
    embed_code 'alert new_hash.has_key?("1")'
    embed_code 'alert new_hash.has_value?("one")'
    para "Try typing these in and press the 'Run' button for each of the methods!"
  end
  
  page "Let's tie these Hashes and Arrays together!" do 
    para "We've looked at two different data structures that are able to hold data for us and let us access ",
         "certain parts of the collections.  Both Arrays and Hashes are commonly used by programmers and are great to ",
         " have knowledge about!  Both of these data structures have so many methods that can be read about in the ",
         " Ruby Documentation: http://www.ruby-doc.org/core/.  Now with Arrays and Hashes you should be able to ",
         "keep your data organized and usable!"
  end

end
