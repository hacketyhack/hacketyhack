require 'h-ety-h/artist'
require 'h-ety-h/markup'

module HH::Editor
  include HH::Markup
  include HH::Artist
  include HH::Dingbat
  include HH::Foley

  def editor(script = {})
    @str = script[:script] || ""
    name = script[:name] || "A New Program"
    @editor =
      stack :margin_left => 50, :margin_top => 22, :width => 1.0, :height => 92 do
        @sname = subtitle name, :font => "Lacuna Regular", :size => 22,
          :margin => 0, :wrap => "trim"
        @stale = para(script[:mtime] ? "Last saved #{script[:mtime].since} ago." :
          "Not yet saved.", :margin => 0, :stroke => "#39C")
      end
      stack :margin_left => 38, :width => 1.0, :height => -92 do
        background white(0.4), :width => 38
        @scroll =
        flow :width => 1.0, :height => 1.0, :margin => 2, :scroll => true do
          stack :width => 37, :margin_right => 6 do
            @ln = para "1", :font => "Liberation Mono", :stroke => "#777", :align => "right"
          end
          stack :width => -37, :margin_left => 6, :margin_bottom => 60 do
            @t = para "", :font => "Liberation Mono", :stroke => "#662",
              :wrap => "trim", :margin_right => 28
            @t.cursor = 0
            def @t.hit_sloppy(x, y)
              x -= 6
              c = hit(x, y)
              if c
                c + 1
              elsif x <= 48
                hit(48, y)
              end
            end
          end
          @compl = stack :top => -100, :left => 0, :width => 20, :height => 20, :hidden => true do
            background white(0.8), :curve => 4
            image "#{HH::STATIC}/icon-art.png", :margin => 2 do
              artist { |code| onkey(code) }
              @compl.hide
            end
          end
          motion do |x, y|
            c = @t.hit_sloppy(x, y)
            if c
              if self.cursor == :arrow
                self.cursor = :text
              end
              if self.mouse[0] == 1
                if @t.marker.nil?
                  @t.marker = c
                else
                  @t.cursor = c
                end
              end
            elsif self.cursor == :text
              self.cursor = :arrow
            end
          end
          click do |_, x, y|
            c = @t.hit_sloppy(x, y)
            if c
              @t.marker = nil
              @t.cursor = c
            end
          end
          leave { self.cursor = :arrow }
        end
      end

    stack :height => 40, :width => 112, :bottom => 20, :right => 30 do
      saver = proc do |name|
        unless name
          msg = ""
          while true
            name = ask(msg + "Give your program a name.")
            break if name.nil? or not HH.script_exists?(name)
            msg = "You already have a program named '" + name + "'.\n"
          end
        end
        if name
          script[:name] = name
          HH.save_script(script[:name], @str)
          script[:mtime] = Time.now
          @sname.text = script[:name]
          @stale.text = "Last saved #{script[:mtime].since} ago."
        end
      end
      @copy_button = 
        glossb "Copy", :width => 60, :top => 2, :left => 0 do
          saver[nil]
        end
      @save_button =
        glossb "Save", :width => 60, :top => 2, :left => 0, :hidden => true do
          saver[script[:name]]
          timer 0.1 do
            @save_button.hide
            @copy_button.show
          end
        end
      glossb "Run", :width => 52, :top => 2, :left => 60 do
        eval(@str, HH.anonymous_binding)
      end
    end

    every 20 do
      if script[:mtime]
        @stale.text = "Last saved #{script[:mtime].since} ago."
      end
    end

    def onkey(k)
      case k when :shift_home, :shift_end, :shift_up, :shift_left, :shift_down, :shift_right
        @t.marker = @t.cursor unless @t.marker
      end

      case k
      when String
        @str[*@t.highlight] = k
        @t.cursor = :marker
        @t.cursor += k.length
      when :backspace, :shift_backspace, :control_backspace
        if @t.cursor > 0 and @t.marker.nil?
          @t.marker = @t.cursor - 1
        end
        sel = @t.highlight
        if sel[0] > 0 or sel[1] > 0
          @str.slice!(*sel)
          @t.cursor = :marker
        end
      when :delete
        sel = @t.highlight
        sel[1] = 1 if sel[1] == 0
        @str.slice!(*sel)
        @t.cursor = :marker
      when :tab
        case @compmode
        when :art
          artist { |code| onkey(code) }
        when :dingbat
          dingbattery { |code| onkey(code) }
        when :sound
          foley { |code| onkey(code) }
        else
          @str[*@t.highlight] = "  "
          @t.cursor = :marker
          @t.cursor += 2
        end
      when :alt_q
        @action.clear { home }
      when :control_a, :alt_a
        @t.marker = 0
        @t.cursor = @str.length
      when :control_x, :alt_x
        if @t.marker
          self.clipboard = @str[*@t.highlight]
          sel = @t.highlight
          sel[1] = 1 if sel[1] == 0
          @str.slice!(*sel)
          @t.cursor = :marker
        end
      when :control_c, :alt_c, :control_insert
        if @t.marker
          self.clipboard = @str[*@t.highlight]
        end
      when :control_v, :alt_v, :shift_insert
        clip = self.clipboard
        @str[*@t.highlight] = clip
        @t.cursor = :marker
        @t.cursor += clip.length
      when :shift_home, :home
        nl = @str.rindex("\n", @t.cursor - 1) || -1
        @t.cursor = nl + 1
      when :shift_end, :end
        nl = @str.index("\n", @t.cursor) || @str.length
        @t.cursor = nl
      when :shift_up, :up
        if @t.cursor > 0
          nl = @str.rindex("\n", @t.cursor - 1)
          if nl
            horz = @t.cursor - nl
            upnl = @str.rindex("\n", nl - 1) || -1
            @t.cursor = upnl + horz
            @t.cursor = nl if @t.cursor > nl
          end
        end
      when :shift_down, :down
        nl = @str.index("\n", @t.cursor)
        if nl
          if @t.cursor > 0
            horz = @t.cursor - (@str.rindex("\n", @t.cursor - 1) || -1)
          else
            horz = 1
          end
          dnl = @str.index("\n", nl + 1) || @str.length
          @t.cursor = nl + horz
          @t.cursor = dnl if @t.cursor > dnl
        end
      when :shift_right, :right
        @t.cursor += 1 if @t.cursor < @str.length
      when :shift_left, :left
        @t.cursor -= 1 if @t.cursor > 0
      end
      if k and @save_button.hidden
        @copy_button.hide
        @save_button.show
      end
      @t.replace *highlight(@str)
      @ln.replace [*1..(@str.count("\n")+1)].join("\n")
    end

    spaces = [?\t, ?\s, ?\n]

    keypress do |k|
      onkey(k)
      if @t.cursor_top < @scroll.scroll_top
        @scroll.scroll_top = @t.cursor_top
      elsif @t.cursor_top + 92 > @scroll.scroll_top + @scroll.height
        @scroll.scroll_top = (@t.cursor_top + 92) - @scroll.height
      end
      compmode = nil
      case k when "t"
        if @str[@t.cursor - 3, 3] == "art"
          if @t.cursor == 3 || spaces.include?(@str[@t.cursor - 4])
            compmode = :art
          end
        elsif @str[@t.cursor - 7, 7] == "dingbat"
          if @t.cursor == 7 || spaces.include?(@str[@t.cursor - 8])
            compmode = :dingbat
          end
        end
      when "d"
        if @str[@t.cursor - 5, 5] == "sound"
          if @t.cursor == 5 || spaces.include?(@str[@t.cursor - 6])
            compmode = :sound
          end
        end
      end

      if @compmode != compmode
        if compmode
          @compl.top = @t.cursor_top
          @compl.left = @t.cursor_left
          @compl.contents[1].path = "#{HH::STATIC}/icon-#{compmode}.png"
          @compl.show
        else
          @compl.hide
        end
        @compmode = compmode
      end
    end

    onkey(nil)
  end
end
