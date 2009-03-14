module HH
  DINGS =
    {"Animals" => [0x21..0x7E, 0xA7, 0xC4, 0xD6, 0xDC, 0xDF, 0xE4, 0xE8, 0xE9, 0xF6, 0xFC],
     "Arcade" => [?1, ?9, ?A..?Z, ?a..?z],
     "Bruegheliana" => [?1..?6, ?a..?z],
     # ... doesn't work on OS X ...
     # "Carr Space" => [?\s..?&, ?(..?+, ?:, ?<, ?>, ?A..?Z, ?^, ?_, ?{..?~],
     "Chess Utrecht" => [?B, ?K..?R, ?T, ?V, ?W, ?b, ?k..?r, ?t, ?v, ?w],
     "Even More Dings JL" => [?#..?&, ?(..?*, ?0..?9, ?@..?Z, ?a..?z],
     "Fontalicious" => [?!..?~],
     "Free" => [?!..?~, 0xA1..0xA5, 0xA7..0xAC, 0xAE..0xB1, 0xB4..0xB7, 0xBA, 0xBB,
                0xBF, 0xC2, 0xC3, 0xC6, 0xD2..0xD5, 0xD8, 0xDA, 0xDF, 0xE6, 0xF7,
                0xF8], # 0x152, 0x153, 0x192],
     "Illustries" => [?a..?z],
     "Outer Space JL" => [?/, ?>, ?A..?Z, ?a..?z],
     "Oxygene1" => [?a..?z, ?{, ?~],
     "Playing Cards" => [??, ?A..?Z, ?a..?z, ?1..?6, ?!, ?@, ?#..?%, ?^],
     "Silhouette" => [0x2C, 0x2E, 0x3A, 0x3B, ?A..?Z]
    }

  WRONG = {"Oxygene 1" => "Oxygene1", "Silhouette\231" => "Silhouette\342\204\242",
    "Fontalicious Thingbats" => "Fontalicious", "Free Regular" => "Free"}

  def self.utf8chr(c)
    if c > 0x80
      [0xC0 | (c >> 6), 0x80 | c & 0x3F].pack("C*")
    else
      c.chr
    end
  end

  def self.font_name(name)
    self.load_font(name)[1]
  end

  def self.load_font(name)
    @fonts ||= {}
    unless @fonts.has_key? name
      fn = font("#{HH::FONTS}/#{name}.ttf").first
      fn = WRONG[fn] || fn
      @fonts[name] = fn
    end
    [HH::DINGS[name], @fonts[name]]
  end

  DINGS.keys.sort.each do |k|
    load_font(k)
  end

  module Dingbat
    def dingbattery indent = 0, &blk
      dialog :title => "Hackety Hack Dingbats", :width => 440, :height => 500 do
        style(Shoes::Link,      :underline => 'none', :stroke => "#777")
        style(Shoes::LinkHover, :underline => 'none', :stroke => "#DFA")

        @font = HH::DINGS.keys.sort[0]
        background "#333".."#002"

        def letters ary, f, blk
          ary.map do |x|
            case x when Fixnum
              [link(HH.utf8chr(x), :font => f, :size => 80) {
                blk[%{("#@font:#{x}")}]; close }, " "]
            else
              letters x, f, blk
            end
          end
        end

        make = proc do
          l, f = HH.load_font(@font)
          l = letters(l, f, blk)
          para(*l)
        end

        stack :margin => 20 do
          stack :width => 1.0, :height => 60 do
            para "Dingbat set", :stroke => "#FFF", :size => 12, :margin => 2
            list_box :items => HH::DINGS.keys.sort, :choose => @font do |box|
              @font = box.text
              @preview.clear &make
            end
          end
          glossb "Cancel", :top => 20, :right => 30, :width => 80, :color => "dark" do
            close
          end
          @preview = flow :margin_top => 20, &make
        end
      end
    end
  end
end

def cat
  c = nil
  window do
    c = dingbat("Animals:67")
  end
  c
end

class Shoes
  def dingbat name, opts = {}
    font, id = name.split(":")
    ding = HH::DINGS[font]
    return unless ding
    case id.to_i when *ding
      opts = {:font => HH.font_name(font), :size => 80}.update(opts)
      para HH.utf8chr(id.to_i), opts
    end
  end
end
