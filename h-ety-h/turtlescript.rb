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
    @heading = 180*DEG # interal heading is rotated by 180 w.r.t user heading
    @pendown = true
    @speed = SPEED
    @paused = true
    @queue = Queue.new
    @image = image "#{HH::STATIC}/turtle.png"
    @image.transform :center
    @turtle_angle = 180
    update_position(@width/2, @height / 2)
    update_turtle_heading
  end

  def start blk
    self.instance_eval &blk
  end

  def start_draw
    @paused = false
    @speed = nil
    @image.hide
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
    update_position(x, y)
  end
  # adds singleton methods
  def backward len=100
    forward(-len)
  end
  def turnleft angle=90
    is_step
    @heading += angle*DEG
    @heading %= 2*PI
    update_turtle_heading
  end
  def turnright angle=90
    turnleft(-angle)
  end
  def setheading direction=180
    is_step
    direction += 180
    direction %= 360
    @heading = direction*DEG
    update_turtle_heading
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
    update_position(x, y)
  end
  def center
    go(200, 200)
  end
  def setx x
    is_step
    update_position(x, @y)
  end
  def sety y
    is_step
    update_position(@x, y)
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
      @speed = SPEED if @speed.nil?
      step
    end
    @paused # return value
  end

  def draw_all
    start_draw
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
    move_turtle_to_top
  end

  private
  def update_position x, y
    @x, @y = x, y
    @image.move(x.round - 16, y.round - 16) unless drawing?
  end


  def update_turtle_heading
    # update turtle image
    angle_in_degrees = @heading/DEG
    diff = (angle_in_degrees - @turtle_angle).round
    @turtle_angle += diff
    @image.rotate(diff) unless drawing?
  end

  def move_turtle_to_top
    return if drawing?
    s = @image.style
    @image = image "#{HH::STATIC}/turtle.png"
    @image.style s
  end

  def is_step
    return if drawing?
    display
    if @paused
      # wait for step
      @queue.deq
    else
      sleep 1.0/@speed
      if @paused # if it got paused in the meantime
        @queue.deq
      end
    end
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

  def drawing?
    @speed.nil? and not @paused
  end
end

module Turtle
  def self.draw opts={}, &blk
    opts[:draw] = true
    start opts, &blk
  end

  def self.start opts={}, &blk
    w = opts[:width] || Shoes::Turtle::WIDTH
    h = opts[:height] || Shoes::Turtle::HEIGHT
    opts[:width] = w + 20
    opts[:height] = h + ( opts[:draw]? 20 : 100)

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
            @next_command = para 'start', :font => 'Liberation Mono'
            t.next_command = @next_command
          end
        end
        glossb "execute", :color => 'dark', :width => 100, :right => '-0px' do
          t.step
        end
      end unless opts[:draw]
      flow do
        glossb "slower", :color => 'dark', :width => 100 do
          t.speed /= 2 if t.speed > 2
        end
        @toggle_pause = glossb "play", :color => 'dark', :width => 100 do
          paused = t.toggle_pause
          if paused
            @toggle_pause.text = 'play'
          else
            @toggle_pause.text = 'pause'
          end
        end
        glossb "faster", :color => 'dark', :width => 100 do
          t.speed *= 2
        end
        glossb "go to end", :color => 'dark', :right => '-0px', :width => 100 do
          t.draw_all
        end
      end unless opts[:draw]
      #debugger
      if opts[:draw]
        Thread.new do
          t.start_draw
          sleep 0.1
          t.instance_eval &blk
        end
      else
        Thread.new do
          t.instance_eval &blk
          @next_command.replace("*** END ***")
        end
      end
    end
  end
end
