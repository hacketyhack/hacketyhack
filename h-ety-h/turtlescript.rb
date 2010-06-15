require 'thread'

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
    @queue = Queue.new
  end

  def reset
    set_defaults
    clear
  end
  def forward len=100
    is_step
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

  def step
    #puts "step"
    @queue.enq nil
  end

  def play
    #puts "play"
  end

  def pencolor *args
    is_step
    stroke *args
  end

  def pensize *args
    is_step
    strokewidth *args
  end

  alias clear_orig clear
  alias background_orig background

  def clear *args
    in_step
    clear_orig *args
  end
  def background *args
    is_step
    background_orig *args
  end

  private
  def is_step
    display
    #this_method caller[0][/`([^']*)'/, 1] end
    @queue.deq
  end

  def display
    puts caller[1..3].join("\n")
  end
end

module Turtle
  def self.start opts={}, &blk
    w = opts[:width] || Shoes::Turtle::WIDTH
    h = opts[:height] || Shoes::Turtle::HEIGHT
    opts[:width] = w+20
    opts[:height] = h+100
    opts[:align] = 'center'
    Shoes.app opts do
      t = nil
      stack :height => h + 20 do
        background gray
        stack :top => 10, :left => 10, :width => w, :height => h do
          background white
          t = turtle
        end
      end
      flow do
        button "step" do
          t.step
        end
        button "play" do
          t.play
        end
      end
      Thread.new {t.instance_eval &blk}
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