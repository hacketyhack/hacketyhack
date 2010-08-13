# A simple _/\_ Fractal
def base scale
  forward scale
end

ANGLE = 70
def recursive scale
  method = scale < 3 ? :base : :recursive
  scale /= 3.0
  send method, scale
  turnleft ANGLE
  send method, scale
  turnright ANGLE*2
  send method, scale
  turnleft ANGLE
  send method, scale
end

alias fractal recursive

Turtle.draw do
  goto 20, 300
  turnright
  fractal(1000)
end