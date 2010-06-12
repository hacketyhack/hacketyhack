class Shoes::Turtle < Shoes::Widget
  WIDTH = 400
  HEIGHT = 400
  include Math
  DEG = PI / 180.0

  def initialize
    @width = WIDTH
    @height = WIDTH
    style width => @width, :height => @height
    @heading = 180*DEG
    @x = @width / 2
    @y = @height / 2
    @pendown = true
    @speed = 10
  end

  def reset
    set_defaults
    clear
  end
  def forward len=100
    x = len*sin(@heading) + @x
    y = len*cos(@heading) + @y
    if @pendown
      l = [@x, @y, x, y]
      line(*l)
    end
    @x, @y = x, y
  end
  # adds singleton methods
  def backward len=100
    forward(-len)
  end
  def turnleft angle=90
    @heading += angle*DEG
    @heading %= 2*PI
  end
  def turnright angle=90
    turnleft(-angle)
  end
  def setheading direction=180
    direction += 180
    direction %= 360
    @heading = direction*DEG
  end
  def penup
    @pendown = false
  end
  def pendown
    @pendown = true
  end
  def isdown?
    return @pendown
  end
  def go x, y
    @x, @y = x, y
  end
  def center
    go(200, 200)
  end
  def setx x
    @x = x
  end
  def sety y
    @y = y
  end
  def getx
    @x
  end
  def gety
    @y
  end
  def getposition
    [@x, @y]
  end

  def getheading
    @heading
  end

  alias pencolor stroke
  alias pensize strokewidth

  # already in shoes:
  # clear
  # background
end

module Turtle
  def self.start opts={}, &blk
    opts[:width] ||= Shoes::Turtle::WIDTH+20
    opts[:height] ||= Shoes::Turtle::HEIGHT+20
    opts[:align] = 'center'
    Shoes.app opts do
      stack :width => Shoes::Turtle::WIDTH, :height => Shoes::Turtle::HEIGHT,
        :left => 10, :top => 10 do
        turtle.instance_eval &blk
      end
    end

  end
end

Turtle.start do
  # barbwire
  background yellow
  pencolor brown
  pensize 2
  go 30, 200
  setheading 180
  1000.times do
    forward 20
    turnleft rand(10)
    backward 10
  end
end