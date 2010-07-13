# contains a dingbat (shapes using fonts) editor to easily add dingbat codes
# into the text editor

module HH::Dingbat
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
