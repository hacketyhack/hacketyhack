require 'h-ety-h/boot'

Turtle.start do
  background blue
  pencolor yellow
  30.times do
    go rand(400), rand(400)
    setheading rand(360)
    len = 5 + rand(30)
    5.times do
      forward len
      turnleft 180-360/10
    end
  end
end