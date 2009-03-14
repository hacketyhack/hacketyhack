def scroll_box(opts = {}, &blk)
  opts = {:width => 1.0, :height => 300, :scroll => true}.merge(opts)
  stack opts, &blk
end

class Glossb < Shoes::Widget
  def initialize(name, opts, &blk)
    fg, bgfill = "#777", "#DDD"
    case opts[:color]
      when "dark"; fg, bgfill = "#CCC", "#000"
      when "yellow"; fg, bgfill = "#FFF", "#7AA"
      when "red"; fg, bgfill = "#FF5", "#F30"
    end

    stack :margin => 4 do
      background bgfill, :curve => 5
      @txt = para link(name, :underline => 'none', :stroke => fg) {},
        :align => 'center', :margin => 4, :size => 11
      hover { @over.show }
      leave { @over.hide }
    end
    @over = stack :top => 0, :left => 0, :margin => 2, :hidden => true do
      background bgfill, :curve => 5
      @txt = para link(name, :underline => 'none', :stroke => fg) {},
        :align => 'center', :margin => 4, :size => 14, :weight => "bold"
    end
    click &blk
  end
end

class Lightboard < Shoes::Widget
  def initialize(width, height, actual = width * height)
    @opts = []
    nostroke
    resize(width, height, actual)
  end
  def coords(x, y, opts)
    at((y * @width) + x, opts)
  end
  def at(i, opts)
    return if i > @actual
    r, p = self.contents[i * 2], self.contents[(i * 2) + 1]
    @opts[i] = (@opts[i] || {}).update(opts)
    if opts[:text]
      p.text = opts[:text]
    end
    if opts[:fill]
      r.fill = opts[:fill]
    end
  end
  def fits(length)
    r = Math.sqrt(length)
    resize(r.round, r.ceil, length)
  end
  def resize(width, height, actual = width * height) 
    @width, @height, @actual = width, height, actual
    build
  end
  def build
    height = parent.height / @height
    width = parent.width / @width
    clear do
      @actual.times do |i|
        y = i / @width
        x = i % @width
        top = y * height
        left = x * width
        opts = @opts[i] || {}
        rect left + 4, top + 4, width - 8, height - 8,
          :curve => 12, :fill => opts[:fill] || white
        para opts[:text] || "", :top => top + (height * 0.5) - 32,
          :left => left, :width => width, :align => "center",
          :size => 31, :font => "Lacuna Regular"
      end
    end
  end
end

module HH::Widgets
  def splash
    nostroke
    background black
    color_names = Shoes::COLORS.keys

    @c = :gray
    @r = star :top => 410, :left => 310, :outer => 80, :inner => 100
    @s =
      stack :top => -400, :left => 100, :width => 370, :height => 370 do
        @mask = mask do
          star 210, 210, 130, 500, 90
        end
        image "#{HH::STATIC}/splash-hand.png", :top => 84, :left => 84
      end
    @t = title span(" Welcome to\n", :size => 15), strong("Hackety Hack"),
           :stroke => black, :top => 180, :left => 80, :font => "Lacuna Regular"
    @b = glossb "Ready", :top => 280, :left => 80, :width => 80, :hidden => true do
      @an.stop
      @ban = @s.parent.animate(30) do |i|
        @s.parent.move(-(i*40), 0)
        if i == 30
          @s.parent.remove
        end
      end
    end
    # @v = video "music.wav",
    #       :autoplay => true, :width => 0, :height => 0, :top => -100, :left => -100
    @an = animate(30) do |i|
      @mask.clear do
        rotate 1
        star 210, 210, 130, 500, 90
      end
      if i == 60
        @b.show
      end
      if @s.top < 198
        dist = (208 - @s.top) / 6
        dist = 10 if dist > 10
        @s.top += dist
        if @s.top > -40
          @t.stroke = gray(@s.top + 55)
        end
      else
        if @v
          @v.remove
          @v = nil
        end
        o = @r.style[:outer]
        if o > 500
          @r.style :inner => 100, :outer => 80, :points => (10..80).rand
          @c = color_names[(0..color_names.length).rand]
        elsif o > 200
          @r.style :fill => send(@c, (500 - o).abs * 0.01), :outer => o + 10
        else
          @r.style :fill => send(@c, (0.1..0.6).rand), :outer => o + 1
        end
      end
    end
  end

  def britelink icon, name, time = nil, bg = "#8c9", &blk
    bg = background bg, :curve => 6, :height => 29, :hidden => true
    flow :margin => 4 do
      image HH::STATIC + "/" + icon, :margin_right => 6, :margin => 3
      p1 = link(name, :stroke => black, :underline => "none", &blk)
      para p1, :size => 13, :font => "Lacuna Regular", :margin => 0,
        :wrap => "trim", :width => 280
      if time
        p2 = para time.short, :stroke => "#396", :font => "Lacuna Regular",
          :size => 9, :margin => 4, :margin_bottom => 0
      end
      ele = image 1, 1
      p1.hover do
        p1.parent.stroke = p1.stroke = white
        p2.stroke = "#FF5" if time
        bg.width = ele.left + 10
        bg.show
      end
      p1.leave do
        p1.parent.stroke = p1.stroke = black
        p2.stroke = "#396" if time
        bg.hide
      end
    end
  end
end
