require 'thread'

class Shoes::Turtle < Shoes::Widget
  # default values
  WIDTH = 400
  HEIGHT = 400
  SPEED = 4 # power of two
  
  include Math
  DEG = PI / 180.0

  # para with the next command written on it
  attr_writer :next_command
  attr_accessor :speed # powers of two

  def initialize
    @width = WIDTH
    @height = WIDTH
    style width => @width, :height => @height
    @heading = 180*DEG
    @x = @width / 2
    @y = @height / 2
    @pendown = true
    @speed = SPEED
    @paused = true
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
    is_step
    @heading += angle*DEG
    @heading %= 2*PI
  end
  def turnright angle=90
    turnleft(-angle)
  end
  def setheading direction=180
    is_step
    direction += 180
    direction %= 360
    @heading = direction*DEG
  end
  def penup
    @pendown = false
  end
  def pendown
    is_step
    @pendown = true
  end
  def isdown?
    return @pendown
  end
  def go x, y
    is_step
    @x, @y = x, y
  end
  def center
    go(200, 200)
  end
  def setx x
    is_step
    @x = x
  end
  def sety y
    is_step
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
    @queue.enq nil
  end

  def toggle_pause
    @paused = !@paused
    if !@paused
      step
    end
  end

  def draw_all
    @paused = false
    @speed = nil
    step
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
    display if @speed
    if @paused
      # wait for step
      @queue.deq
    elsif not @speed.nil?
      sleep 1.0/@speed
      if @paused # if it got paused in the meantime
        @queue.deq
      end
    end
    # if not paused and speed is nil continue (fastest)
  end

  def display
    method = nil
    1.upto 4 do |i|
      m = caller[i][/`([^']*)'/, 1]
      if m.nil?
        break
      else
        method = m
      end
    end
    @next_command.replace(method)
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
        stack do
          flow do
            para "next command: "
            t.next_command = para '???', :font => 'Liberation Mono'
          end
        end
        button "execute", :right => '-0px' do
          t.step
        end
      end
      flow do
        button "slower" do
          t.speed /= 2 if t.speed > 2
        end
        @toggle_pause = button "play" do
          paused = t.toggle_pause
          if paused
            #@toggle_pause.text.replace('play')
          else
            #@toggle_pause.text.replace('pause')
          end
        end
        button "faster" do
          t.speed *= 2
        end
        button "go to end", :right => '-0px' do
          t.draw_all
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