# encoding: UTF-8

lesson_set "5: Better Guessing Game" do

	lesson "Hello There!"
	  page "Let's get started" do
	    para "Hey, did you like making that guessing game at the end of Beginner Ruby? Great! Let's make it BETTER. In this lesson we'll add ways to:"
	    
	    para "* Keep the game running until the player guesses correctly"
	    para "* Give the player some hints"
	    para "* Count the number of guesses"
	    para "* End the game after 10 tries"
	    para "* Create a random number, instead of just using 42"
	    
	    para "Let's do it!"
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
	  
	  page "How did it go again?" do
	    para "Here's the code from the original guessing game:"
	    
	    embed_code 'secret_number = 42.to_s
guess = ask "I have a secret number. Take a guess, see if you can figure it out!"
if guess == secret_number
  alert "Yes! You guessed right!"
else
  alert "Sorry, you\'ll have to try again."
end'
      
      para "If you don't have this saved, type it in again and save it. Before we really get rolling, let's add something at the very top:"
      embed_code 'guess = nil'
      para "This just makes an guess equal nothing at all. It'll help out later, honest. Before we get going, see if you can guess how to add the features we want!"
    end

  lesson "Yeah! New code!"
    page "A little bit of logic" do
      para "So we want to keep this game going. For how long?  Well, as long as the player keeps guessing wrong, right? How do we say that the player is guessing wrong?"
      embed_code 'guess != secret_number'
      para "The ", code("!="), " means 'not equal to.' You can try it out in a new editor:"
      embed_code 'alert 5 != 10
alert 5 != 5'
      para "This is the opposite of equals. Things like this are called comparisons. Here's a few more ways of comparing numbers:"
      embed_code 'alert 5 > 10
alert 5 < 10'
      para "The first one means '5 is greater than 10' and the second means '5 is less than 10.' Which one comes back as true?"      
    end
    
    page "The While Loop: Ruby on Repeat!" do
      para "The first thing we'll add to this game is a while loop. We call it a loop because it goes around and around. Check it out, it's easy!"
      embed_code 'guess = nil
secret_number = 42.to_s
while guess != secret_number
    guess = ask "I have a secret number. Take a guess, see if you can figure it out!"
    if guess == secret_number
      alert "Yes! You guessed right!"
    else
      alert "Sorry, you\'ll have to try again."
    end
  end'
      para "Here's how you read the new code: 'While guess is not equal to secret_number... do everything until the end.' Run it and see! As long as you guess wrong it will keep asking you to guess. And that's what a while loop does!"
      para "You might have noticed that ", code("guess = nil"), " is coming in handy. Without it, we're asking the computer a question about guess before we even mention it. Without that, the code breaks."
    end
  
    page "Get a clue" do
      para "Since the player can keep guessing, how about we help them out? Instead of just 'Sorry, try again', how about this?"
      embed_code 'guess = nil
secret_number = 42.to_s
while guess != secret_number
  guess = ask "I have a secret number. Can you guess it?"
  if guess == secret_number
    alert "Yes! You guessed right!"
  elsif guess > secret_number
      alert "Sorry, you guessed too high."
  else
      alert "Sorry, you guessed too low."
  end
end'
      para "Hey, look at that greater than sign coming back! Remember what that means?"
      para "There's something else there too: ", code("elsif"), ". That's just a short way of saying ", code("else"), " and ", code("if"), " at the same time."
      para "Run that code! Try numbers above and below 42. Now this is starting to look like a game, huh?"
    end
    
    page "Counters and Breaks" do
      para "This is fun and all, but most games have some kind of time limit right? Or maybe you only get a few lives. So how about we put the player under some pressure and end the game after 10 tries? The first step is counting the tries, which we can do like so:"
      embed_code 'counter = 0
guess = nil
secret_number = 42.to_s
while guess != secret_number
  guess = ask "I have a secret number. Can you guess it?"
  counter += 1
  if guess == secret_number
    alert "Yes! You guessed right!"
  elsif guess > secret_number
      alert "Sorry, you guessed too high."
  else
      alert "Sorry, you guessed too low."
  end
end'
      para "You already know what this does! The counter starts at 0. Every time the player guesses, it goes up by 1. That's what ", code("+="), " does. What else can we do? Add this just before the last ", code("end"),":"
      embed_code 'if counter == 10
  alert "You used 10 guesses. Please play again."
  break
end'
      para "Break is super cool! It let's you 'break out' from a loop!"
    end
    
    page "It's the Final Countdown!" do
      para "It would really add to the sense of urgency if the player knew how many tries were left. Let's put the counter in the alert!"
      embed_code 'alert "Sorry, you guessed too high. Guesses used: " + counter.to_s + "/10"'
      para "Do you remember what ", code("to_s"), " does? It makes the counter number a string. The plus signs let us stick a the counter variable in the middle of the string. When you do that, it's called concatenation."
      para "You know what? You're doing so well, you can probably put the counter in the other alerts all on your own!"
    end
    
  lesson "This is totally random"
    page "The easiest refactor ever" do
      para "This game is pretty lame once you know the number, right? We're going to 'refactor' it, which is a programming word for 'redo it and make it work better.'"
      para "Try replacing ", code("42"), " with ", code("rand(100)")
      para "This means 'pick a random number from 0-99.' The count starts at 0 because it's just a crazy thing that programmers tend to do. You can use any number in random, so that your little cousin can play 0-10, and you, being an obvious super-genius, can play 0-1000."
      para "That's pretty much it! You can check out this game in the samples, and see if it matches yours!"
    end
  
  lesson "Summary"
    page "Awesome job!" do
      para "Hey, that was kinda fun! And we learned some stuff, too!"
      para "* ", code("While"), " loops"
      para "* ", code("!="), " , ", code(">"), " and ", code("<"), " comparisons"
      para "* counting with ", code("+=")
      para "* ", code("rand()")
      para "* ", code("break")
      para "* Concatenation with ", code("+")
      para "Way to go! Check out 'Data Structures' next, where you can start doing some of totally hardcore hacking!"
    end
  
end