module HH::Artist
  def artist indent = 0, &blk
    dialog :title => "Hackety Hack Artist", :resizable => false do
      background "#eee"
      nofill

      @cX, @cY = 0, 0
      @graph_size = 30
      @mode = :move
      @bump = [0, 0, false]
      @art = [[:M, 0, 0]]

      def coord(c)
        ((c.to_f / @graph_size) * 5).round * 0.2
      end
      def real(c)
        (coord(c) * @graph_size).round
      end
      def bump(b)
        b * (@graph_size/2.0)
      end
      def draw_graph
        @graph.clear do
          ((width / @graph_size) + 1).times do |x|
            line x * @graph_size, 0, x * @graph_size, width
          end
          ((height / @graph_size) + 1).times do |y|
            line 0, y * @graph_size, width, y * @graph_size
          end
        end
      end
      def draw_overlay
        @overlay.show
        @overlay_timer.stop if @overlay_timer
        @overlay_timer = timer(2) { @overlay.hide }
      end

      stack :top => 0, :left => 0, :width => 1.0, :height => 1.0 do
        @graph = stack :top => 0, :left => 0 do
          stroke rgb(0.8, 0.8, 0.8, 0.6)
        end
        @cursor = stack :top => 0, :left => 0, :width => 72 do
          background black(0.4), :curve => 4
          @cursor_oval = oval -10, -10, 10
          @cursor_txt = para "0, 0", :size => 10,
            :stroke => white, :margin => 2, :align => "center"
        end
        glossb "OK", :bottom => 50, :right => 120, :width => 50 do
          src = " do\n"
          ind = " " * indent
          art = @art[0..-2]
          art.shift if art[0] == [:M, 0, 0]
          art.each do |cmd, cx, cy, b1, b2, b3|
            cmd = case cmd
                  when :C; "color"
                  when :P; "pencil"
                  when :L; "line"
                  when :R; "rect"
                  when :O; "oval"
                  when :A; "arc"
                  when :M; "move"
                  end
            params = [cx, cy, b1, b2, b3]
            params.pop if b3 == false
            params.pop if b2 == 0
            params.pop if b1 == 0
            src << "#{ind}  #{cmd} " + params.compact.join(', ') + "\n"
          end
          src << "#{ind}end"
          blk[src]
          close
        end
        glossb "Cancel", :bottom => 50, :right => 30, :width => 80 do
          close
        end
        @overlay = stack :top => 0.2, :left => 0.2,
                         :width => 0.6, :height => 0.6, :hidden => true do
          stroke "#777"
          background white(0.4), :curve => 10
          @overlay_key = banner "L", :align => 'center', :size => 40,
            :font => "Lacuna Regular"
          stack :top => 0.8 do
            @overlay_name = para "LINE", :align => 'center', :size => 16,
              :font => "Lacuna Regular"
          end
          @overlay_shape = stack :top => 0.5, :left => 0.5 do
            strokewidth 4
          end
        end

        @point_at = [0, 0]
        @point = stack :top => 0, :left => 0 do
          fill "#f63"
          strokewidth 0.3
          oval -3, -3, 6
        end
      end

      keypress do |k|
        case k
        when :escape
          @mode = :move
          @overlay_key.replace "MOVE"
          @overlay_name.replace "(Esc)"
          @overlay_shape.clear do
            oval -10, -10, 20
          end
          draw_overlay
          draw_shape_hint
        when "c", "C"
          c = ask_color "What color?"
          @art.pop if @art.last[0] == :C
          @art << [:C, c]
          draw_shape_hint
        # when "e", "E" # move the cursor to the last :M (the end of the shape)
        when "p", "P"
          c = ask_color "Pencil color?"
          @art.pop if @art.last[0] == :P
          @art << [:P, c]
          draw_shape_hint
        when "r", "R"
          @mode = :rect
          @overlay_key.replace "RECTANGLE"
          @overlay_name.replace "(R)"
          @overlay_shape.clear do
            oval -50, -50, 2
            oval 50, -50, 2
            oval 50, 50, 2
            oval -50, 50, 2
            rect -49, -49, 100
          end
          draw_overlay
        when "a", "A"
          @mode = :arc
          @overlay_key.replace "ARC"
          @overlay_name.replace "(A)"
          @overlay_shape.clear do
            oval -51, 0, 2
            oval 0, 49, 2
            arc 0, 0, 100, 100, Shoes::PI, Shoes::HALF_PI
          end
          draw_overlay
          draw_shape_hint
        when "o", "O"
          @mode = :oval
          @overlay_key.replace "OVAL"
          @overlay_name.replace "(O)"
          @overlay_shape.clear do
            oval -51, 0, 2
            oval 49, 0, 2
            arc 0, 0, 100, 100, 0, Shoes::TWO_PI
          end
          draw_overlay
          draw_shape_hint
        when "l", "L"
          @mode = :line
          @overlay_key.replace "LINE"
          @overlay_name.replace "(L)"
          @overlay_shape.clear do
            oval -50, -50, 2
            oval 50, 50, 2
            line -50, -50, 50, 50
          end
          draw_overlay
          draw_shape_hint
        when "f", "F"
          @bump[2] = !@bump[2]
          draw_shape_hint
        when :left
          @bump[0] -= 1
          draw_shape_hint
        when :right
          @bump[0] += 1
          draw_shape_hint
        when :up
          @bump[1] -= 1
          draw_shape_hint
        when :down
          @bump[1] += 1
          draw_shape_hint
        when "+", "="
          @graph_size += 5
          draw_all
        when "-", "_"
          @graph_size -= 5
          draw_all
        end
      end

      def draw_shape
        @shape.remove if @shape
        x, y = 0, 0
        before(@point) do
          art = @art
          @shape = 
            Shoes::Art.new(self, :graph => @graph_size) do
              art.each do |cmd, cx, cy, b1, b2|
                if cmd == :C
                  color cx
                  next
                elsif cmd == :P
                  pencil cx
                  next
                end
                x, y =
                  case cmd
                  when :M
                    move cx, cy
                  when :L
                    line cx, cy, b1, b2
                  when :A
                    arc cx, cy, b1, b2
                  when :O
                    oval cx, cy, b1, b2
                  when :R
                    rect cx, cy, b1, b2
                  else
                    [x, y]
                  end
              end
            end.shape
        end
        @point.move x, y
      end

      def draw_shape_hint
        @shape_hint.remove if @shape_hint
        ox, oy, x, y = coord(@point.left), coord(@point.top), coord(@cX), coord(@cY)
        bump, mode = @bump, @mode
        @shape_hint =
          Shoes::Art.new(self, :graph => @graph_size) do
            pencil "#666"
            move ox, oy
            if mode != :move
              send(mode, x, y, *bump)
            end
          end.shape
      end

      def draw_all
        draw_graph
        draw_shape
        draw_shape_hint
      end

      motion do |x, y|
        @cursor_txt.replace "#{coord(x)}, #{coord(y)}"
        @cX, @cY, _x, _y = x, y, -10, -10
        if self.width - x < 100
          x -= 80
          _x = 75
        else
          x += 5
        end
        if self.height - y < 100
          y -= 26
          _y = 21
        else
          y += 5
        end
        @cursor_oval.move _x, _y
        @cursor.move x, y
        draw_shape_hint
      end

      click do |_, x, y|
        return unless _ == 1
        case @mode
        when :move
          @point.move real(x), real(y)
          @art.pop if @art.last[0] == :M
          @art << [:M, coord(x), coord(y)]
        when :line
          @art << [:L, coord(x), coord(y), *@bump]
          @bump = [0, 0, false]
          draw_shape
        when :rect
          @art << [:R, coord(x), coord(y), *@bump]
          @bump = [0, 0, false]
          draw_shape
        when :arc
          @art << [:A, coord(x), coord(y), *@bump]
          @bump = [0, 0, false]
          draw_shape
        when :oval
          @art << [:O, coord(x), coord(y), *@bump]
          @bump = [0, 0, false]
          draw_shape
        end
      end

      start do
        draw_graph
      end
    end
  end
end
