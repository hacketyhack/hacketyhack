# some extensions to shoes (subclasses of Shoes::Widget)
# and auxiliary methods for the hh app (the HH::Widgets mixin)

#def scroll_box(opts = {}, &blk)
#  opts = {:width => 1.0, :height => 300, :scroll => true}.merge(opts)
#  stack opts, &blk
#end

# a glossy button
class Glossb < Shoes::Widget
  def initialize(name, opts={}, &blk)
    fg, bgfill = "#777", "#DDD"
    case opts[:color]
      when "dark"; fg, bgfill = "#CCC", "#000"
      when "yellow"; fg, bgfill = "#FFF", "#7AA"
      when "red"; fg, bgfill = "#FF5", "#F30"
    end

    txt = link(name, :underline => 'none', :stroke => fg) {}
    stack :margin => 4 do
      background bgfill, :curve => 5
      @txt = para txt, :align => 'center', :margin => 4, :size => 11
      hover { @over.show }
      leave { @over.hide }
    end

    @over = stack :top => 0, :left => 0, :margin => 2, :hidden => true do
      background bgfill, :curve => 5
      @txt_over = para txt, :align => 'center', :margin => 4, :size => 14, :weight => "bold"
    end
    @fg = fg
    click &blk
  end

  def text= txt
    new_link = link(txt, :underline => 'none', :stroke => @fg) {}
    @txt.replace(new_link)
    @txt_over.replace(new_link)
  end
end

class IconButton < Shoes::Widget
#  BSIZE = 16
#  MARGIN = 8
#  SIZE = BSIZE + MARGIN * 2
  def initialize (type, tooltip, opts={}, &blk)
    strokewidth 1
    nofill

    @tooltip_text = tooltip

    stack do
      stack :margin => 8, :width => 32, :height => 32 do
        stroke white
        send type
      end

      hover do
        @over.show
        if @tooltip_text
          create_tooltip
        end
      end
      leave do
        @over.hide
        if @tooltip
          @tooltip.hide
          @tooltip.remove
          @tooltip = nil
        end
      end
    end

    style(:width => 32)

    stack :margin => 8, :top => 0, :left => 0 do
       @over = stack :width => 16, :height => 16, :hidden => true do
        background gray(0.8)
        stroke black
        send type
      end
    end

    click &blk
  end
  
  def create_tooltip
    slot = parent
    x, y = left, top
    while not slot.respond_to? :tooltip
      x += slot.left
      y += slot.top
      slot = slot.parent
    end

    @tooltip = slot.tooltip(@tooltip_text, x, y-20,
          :fill => red, :stroke => white)
  end

  def arrow_right
    line(1, 8, 14, 8)
    line(14, 8, 10, 1+3)
    line(14, 8, 10, 15-3)
  end

  def arrow_left
    line(1, 8, 14, 8)
    line(1, 8, 6, 1+3)
    line(1, 8, 6, 15-3)
  end

  def x
    line(2, 2, 13, 13)
    line(2, 13, 13, 2)
  end

  def menu
    rect 2, 2, 11, 11
    line 4, 6, 11, 6
    line 4, 8, 11, 8
    line 4, 10, 11, 10
  end
end

module HH::Tooltip
  def tooltip str, x, y, opts={}
    f = nil
    #opts[:wrap] = "trim"
    slot = self
    app do
    slot.append do
    f = flow  :left => x, :top => y do
      para str, opts
    end
    end
    end
    f
  end
end

#class Lightboard < Shoes::Widget
#  def initialize(width, height, actual = width * height)
#    @opts = []
#    nostroke
#    resize(width, height, actual)
#  end
#  def coords(x, y, opts)
#    at((y * @width) + x, opts)
#  end
#  def at(i, opts)
#    return if i > @actual
#    r, p = self.contents[i * 2], self.contents[(i * 2) + 1]
#    @opts[i] = (@opts[i] || {}).update(opts)
#    if opts[:text]
#      p.text = opts[:text]
#    end
#    if opts[:fill]
#      r.fill = opts[:fill]
#    end
#  end
#  def fits(length)
#    r = Math.sqrt(length)
#    resize(r.round, r.ceil, length)
#  end
#  def resize(width, height, actual = width * height)
#    @width, @height, @actual = width, height, actual
#    build
#  end
#  def build
#    height = parent.height / @height
#    width = parent.width / @width
#    clear do
#      @actual.times do |i|
#        y = i / @width
#        x = i % @width
#        top = y * height
#        left = x * width
#        opts = @opts[i] || {}
#        rect left + 4, top + 4, width - 8, height - 8,
#          :curve => 12, :fill => opts[:fill] || white
#        para opts[:text] || "", :top => top + (height * 0.5) - 32,
#          :left => left, :width => width, :align => "center",
#          :size => 31, :font => "Lacuna Regular"
#      end
#    end
#  end
#end

# splash screen and a link with a similar appearance as the gloss buttons
# included by the hh app
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

  # creates a link having a similar appearance as the gloss buttons
  def britelink icon, name, time = nil, bg = "#8c9", &blk
    bg = background bg, :curve => 6, :height => 29, :hidden => true
    flow :margin => 4, :width => 300 do
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

  # method to create a side tab (actually is just a stack with an image in it)
  # +icon_path+:: the icon displayed in the tab
  # +top+:: if > 0 indicates the distance from the top, else the distance from
  #         the bottom
  # +name+:: text displayed on icon hover
  # +blk+:: the block passed is executed on click
  def sidetab(icon_path, top, name, &blk)
    v = top < 0 ? :bottom : :top
    stack v => top.abs, :left => 0, :width => 38, :margin => 4 do
      bg = background "#DFA", :height => 26, :curve => 6, :hidden => true
      image(icon_path, :margin => 4).
        hover { bg.show; @tip.parent.width = 122; @tip.top = nil; @tip.bottom = nil
          @tip.send("#{v}=", top.abs); @tip.contents[1].text = name; @tip.show }.
        leave { bg.hide; @tip.hide; @tip.parent.width = 40 }.
        click &blk
    end
  end
end
