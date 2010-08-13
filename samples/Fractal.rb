# A simple _/\_ Fractal

def base scale
  forward scale
end

ANGLE = 70
def fractal scale
  method = scale < 3 ? :base : :fractal
  scale /= 3.0
  send method, scale
  turnleft ANGLE
  send method, scale
  turnright ANGLE*2
  send method, scale
  turnleft ANGLE
  send method, scale
end

Turtle.draw do
  goto 20, 300
  turnright
  fractal(1000)
end