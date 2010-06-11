class Shoes
  def add_turtle_methods
    @heading = 180*Turtle::DEG
    @x = 200.0
    @y = 200.0
    @pen_down = true

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

    def self.direction dir=180
      dir += 180
      @heading = dir*Turtle::DEG
    end

    def self.go x, y
      @x, @y = x, y
    end

    def self.center
      go(200, 200)
    end

    def self.penup
      @pen_down = false
    end

    def self.pendown
      @pen_down = true
    end

    alias pencolor stroke
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
  background red
  pencolor white
  go 0, 200
  direction 180
  800.times do
    forward 20
    turnleft(rand(10))
    backward 10
  end
end