counter = 0
guess = nil
secret_number = rand(100).to_s
while guess != secret_number
  guess = ask "I have a secret number. Can you guess it?"
  counter += 1
  if guess == secret_number
    alert "Yes! You guessed right in just "+counter.to_s+" guesses."
  elsif guess > secret_number
      alert "Sorry, you guessed too high. Guesses used: "+counter.to_s+"/10"
  else
      alert "Sorry, you guessed too low. Guesses used: "+counter.to_s+"/10"
  end
 if counter == 10
   alert "You used 10 guesses. Please play again."
   break
 end
end