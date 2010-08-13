# A sky full of stars

Turtle.start do
  background blue
  pensize 2
  pencolor yellow
  30.times do
    goto rand(width), rand(height)
    setheading rand(360)
    len = 5 + rand(30)
    5.times do
      forward len
      turnleft 180-360/10
    end
  end
end
