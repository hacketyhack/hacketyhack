# a turtle graphics library

require 'thread'

class Shoes::TurtleCanvas < Shoes::Widget
  # default values
  WIDTH = 500
  HEIGHT = 500
  SPEED = 4 # power of two
  
  include Math
  DEG = PI / 180.0

  # para with the next command written on it
  attr_writer :next_command, :pen_info
  attr_accessor :speed # powers of two
  attr_reader :width, :height

  def initialize
    @width = WIDTH
    @height = WIDTH
    style width => @width, :height => @height
    @queue = Queue.new
    @image = image "#{HH::STATIC}/turtle.png"
    @image.transform :center
    @speed = SPEED
    @paused = true
    reset
    move_turtle_to_top
  end

  def start_draw
    @paused = false
    @speed = nil
    @image.hide
  end


  ### user commands ###

  def reset
    clear_orig
    @pendown = true
    @heading = 180*DEG # internal heading is rotated by 180 w.r.t user heading
    @pendown = true
    @turtle_angle = 180
    @bg_color = white
    @fg_color = black
    @pen_size = 1
    background_orig @bg_color
    stroke @fg_color
    strokewidth @pen_size
    update_position(@width/2, @height/2)
    update_turtle_heading
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
  def pendown?
    return @pendown
  end
  def goto x, y
    is_step
    update_position(x, y)
  end
  def center
    go(width/2, height/2)
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
    degs = @heading/DEG
    degs += 180
    degs % 360
  end

  ### user commands already in shoes (the first two with another name ###

  def pencolor args
    is_step
    stroke args
    @fg_color = args
    update_pen_info
  end

  def pensize args
    is_step
    strokewidth args
    @pen_size = args
    update_pen_info
  end

  alias clear_orig clear
  alias background_orig background

  def clear *args
    in_step
    clear_orig *args
  end
  def background args
    is_step
    background_orig args
    move_turtle_to_top
    @bg_color = args
    update_pen_info
  end


  ## UI commands: should not be used by the user ##

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
  
  def save filename
    _snapshot :filename => filename, :format => :pdf
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
    bt = caller
    1.upto 4 do |i|
      m = bt[i][/`([^']*)'/, 1]
      if m.nil? || m =~ /^block /
        break
      else
        method = m
      end
    end
    @next_command.replace(method)
  end

  # false if drawing directly the final result
  def drawing?
    @speed.nil? and not @paused
  end

  def update_pen_info
    @pen_info.append do
      background_orig @bg_color
      line 5, 10, 35, 10, :stroke => @fg_color, :strokewidth => @pen_size
    end if @pen_info
  end
end

module Turtle
  def self.draw opts={}, &blk
    opts[:draw] = true
    start opts, &blk
  end

  def self.start opts={}, &blk
    w = opts[:width] || Shoes::TurtleCanvas::WIDTH
    h = opts[:height] || Shoes::TurtleCanvas::HEIGHT
    opts[:width] = w + 20
    opts[:height] = h + ( opts[:draw]? 60 : 130)

    Shoes.app opts do
      extend Turtle # add methods back (after self changed)
      @block = blk

      unless opts[:draw]
        para "pen: "
        @pen_info = stack :top => 5, :width => 40, :height => 20 do
          background white
          line 5, 10, 35, 10
        end
      end

      glossb "save...", :color => 'dark', :right => '-0px', :width => 100 do
        filename = ask_save_file
        unless filename.nil?
          filename += '.pdf' unless filename =~ /\.pdf$/
          @canvas.save filename
        end
      end

      stack :height => h + 20 do
        background gray
        stack :top => 10, :left => 10, :width => w, :height => h do
          shape do
            background white
            @canvas = turtle_canvas
          end
        end
      end
      
      if opts[:draw]
        draw_all
      else
        draw_controls
        @interactive_thread = Thread.new do
          sleep 0.1 # HACK
          @canvas.instance_eval &blk
          @next_command.replace("(END)")
        end
      end
    end
  end

private
  def execute_canvas_code blk
    @canvas.instance_eval do
      shape do
        self.instance_eval &blk
      end
    end
  end

  def draw_controls
    flow do
      stack do
        flow do
          para "next command: "
          @next_command = para 'start', :font => 'Liberation Mono'
          @canvas.next_command = @next_command
        end
      end
      glossb "execute", :color => 'dark', :width => 100, :right => '-0px' do
        @canvas.step
      end
    end

    flow do
      glossb "slower", :color => 'dark', :width => 100 do
        @canvas.speed /= 2 if @canvas.speed > 2
      end
      @toggle_pause = glossb "play", :color => 'dark', :width => 100 do
        paused = @canvas.toggle_pause
        if paused
          @toggle_pause.text = 'play'
        else
          @toggle_pause.text = 'pause'
        end
      end
      glossb "faster", :color => 'dark', :width => 100 do
        @canvas.speed *= 2
      end
      glossb "draw all", :color => 'dark', :right => '-0px', :width => 100 do
        @interactive_thread.kill
        @canvas.reset
        @next_command.replace("(draw all)")
        draw_all
      end
    end
    @canvas.pen_info = @pen_info
  end

  def draw_all
    timer 0.1 do
      @canvas.start_draw
      execute_canvas_code @block
    end
  end
end
