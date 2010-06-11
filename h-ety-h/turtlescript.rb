class Shoes
  def add_turtle_methods args={}
    @width = args[:width] || 400
    @height = args[:height] || 400

    def self.set_defaults
      @heading = 180*Turtle::DEG
      @x = @width/2
      @y = @height/2
      @pen_down = true
    end

    def self.reset
      set_defaults
      clear
    end
    def self.forward len=100
      x = len*Math.sin(@heading) + @x
      y = len*Math.cos(@heading) + @y
      if @pen_down
        l = [@x, @y, x, y]
        line(*l)
      end
      @x, @y = x, y
    end
    # adds singleton methods
    def self.backward len=100
      forward(-len)
    end
    def self.turnleft angle=90
      @heading += angle*Turtle::DEG
      @heading %= 2*PI
    end
    def self.turnright angle=90
      turnleft(-angle)
    end
    def self.setheading dir=180
      dir += 180
      @heading = dir*Turtle::DEG
    end
    def self.penup
      @pen_down = false
    end
    def self.pendown
      @pen_down = true
    end
    def self.isdown?
      return @pen_down
    end
    def self.go x, y
      @x, @y = x, y
    end
    def self.center
      go(200, 200)
    end
    def self.setx x
      @x = x
    end
    def self.sety y
      @y = y
    end
    def self.getx
      @x
    end
    def self.gety
      @y
    end
    def self.getposition
      [@x, @y]
    end

    def self.getheading
      @heading
    end

    alias pencolor stroke
    alias pensize strokewidth

    # already in shoes:
    # clear
    # background

    set_defaults
  end
end


module Turtle
  DEG = Math::PI / 180.0
  def self.start &blk
    Shoes.app :width => 400, :height => 400 do
      add_turtle_methods
      instance_eval &blk
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