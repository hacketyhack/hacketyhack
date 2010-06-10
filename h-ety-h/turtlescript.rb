module Turtle
  include Math
  DEG = PI / 180.0

  def self.start &blk
    include Math
    @heading = 180*DEG
    @x = 200.0
    @y = 200.0
    @pen_down = true
    Shoes.app :width => 400, :height => 400 do
      Turtle.app = self
      Turtle.instance_eval &blk
    end
  end

  def self.forward len=100
    x = len*Math.sin(@heading) + @x
    y = len*Math.cos(@heading) + @y
    if @pen_down
      l = [@x, @y, x, y]
      shoes { line(*l) }
    end
    @x, @y = x, y
  end

  def self.backward len=100
    forward(-len)
  end

  def self.turnleft angle=90
    @heading += angle*DEG
    @heading %= 2*PI
  end

  def self.turnright angle=90
    turnleft(-angle)
  end

  def self.direction dir=180
    dir += 180
    @heading = dir*DEG
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

private
  def self.app= shoes_app
    @app = shoes_app
  end

  def self.shoes &blk
    @app.instance_eval &blk
  end
end

Turtle.start do
  # barbwire
  go 0, 200
  direction 180
  800.times do
    forward 20
    turnleft(rand(10))
    backward 10
  end
end
