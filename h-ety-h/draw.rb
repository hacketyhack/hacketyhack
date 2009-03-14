class Shoes::Art
  attr :shape

  def initialize slot, *a, &b
    @x, @y = 0, 0
    @slot = slot
    opts = a.last
    @graph = 30
    if opts.is_a?(Hash) and opts[:graph]
      @graph = opts[:graph]
    end
    @shape = slot.shape(*a) do
      slot.nofill
      slot.move_to @x, @y
      instance_eval &b
    end
  end

  def convert cx, cy, bx, by, bf
    ox, oy, @x, @y = @x, @y, (cx * @graph).round, (cy * @graph).round
    bx = bx * (@graph/2.0) if bx != 0
    by = by * (@graph/2.0) if by != 0
    return ox, oy, bx, by
  end

  def pencil c
    @slot.stroke c
  end

  def color c
    @slot.fill c
  end

  def move cx, cy
    ox, oy, bx, by = convert cx, cy, 0, 0, 0
    @slot.move_to @x, @y
    return @x, @y
  end

  def line cx, cy, bx = 0, by = 0, bf = false
    ox, oy, bx, by = convert cx, cy, bx, by, bf
    if bx == 0 and by == 0
      @slot.line_to @x, @y
    else
      @slot.curve_to ox, oy,
        ((@x + ox) / 2) + bx, ((@y + oy) / 2) + by,
        @x, @y
    end
    return @x, @y
  end

  def arc cx, cy, bx = 0, by = 0, bf = false
    ox, oy, bx, by = convert cx, cy, bx, by, bf
    mx, my = (@x + ox) / 2, (@y + oy) / 2
    w, h = (@x - ox).to_f, (@y - oy).to_f
    return unless w.abs > 2 or h.abs > 2
    r = Math.sqrt((w ** 2) + (h ** 2))
    ma, ma2 = 0, 0
    if by != 0
      ma, ma2 = Math.atan(h/w), Math.atan(by/(r/2))
      mr = Math.sqrt(((r/2) ** 2) + (by ** 2))
      mx = ox + ((@x < ox ? -1 : 1) * mr * Math.cos(ma + ma2))
      my = oy + ((@x < ox ? -1 : 1) * mr * Math.sin(ma + ma2))
      r = mr * 2
    end
    v = (my < oy ? mx-ox : ox-mx)/(r/2)
    v = -1.0 if v < -1.0
    v = 1.0 if v > 1.0
    a1 = Shoes::HALF_PI + Math.asin(v)
    a2 = a1 + Shoes::PI
    a1, a2 = a2, a1 if my >= oy
    a2 += -(2 * ma2)
    @slot.arc_to mx, my, r, r, a1, a2
    return @x, @y
  end

  def oval cx, cy, bx = 0, by = 0, bf = false
    ox, oy, bx, by = convert cx, cy, bx, by, bf
    mx, my, w, h = (@x + ox) / 2, (@y + oy) / 2, (@x - ox).abs, (@y - oy).abs
    r = Math.sqrt((w ** 2) + (h ** 2))
    return unless r.abs > 2
    @slot.move_to mx + (r / 2), my
    @slot.arc_to mx, my, r, r, 0, Shoes::TWO_PI
    return @x, @y
  end

  def rect cx, cy, bx = 0, by = 0, bf = false
    ox, oy, bx, by = convert cx, cy, bx, by, bf = false
    @slot.move_to @x, @y
    @slot.line_to @x, oy
    @slot.line_to ox, oy
    @slot.line_to ox, @y
    @slot.line_to @x, @y
    return @x, @y
  end
end

module Kernel
  def art *a, &b
    opts, dopt = {}, a.last
    if dopt.is_a?(Hash)
      w = dopt[:width]
      opts[:width] = w if w
      h = dopt[:height]
      opts[:height] = h if h
    end

    if self.respond_to? :shape
      Shoes::Art.new(self, *a, &b).shape
    else
      window(opts) do
        art *a, &b
      end
    end
  end
end
