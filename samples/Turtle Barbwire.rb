# Turtle drawing barbwire

Turtle.start do
  background yellow
  pencolor brown
  pensize 2
  goto 30, 200
  setheading 180
  1000.times do
    forward 20
    turnleft rand(10)
    backward 10
  end
end
