# the messages tab content

class HH::SideTabs::Prefs < HH::SideTab
  def loading_stack *a
    n = nil
    s = stack(*a) do
      background black(0.4), :curve => 12
      stroke white(0.6)
      fill white(0.6)
      para "\nLoading.\n\n", :align => "center", :size => 17,
        :font => "Lacuna Regular", :stroke => white
      o1 = oval -400, 0, 16
      o2 = oval -400, 0, 16
      n = animate do |i|
        v1 = Math.sin(i * 0.2) * 5
        v2 = Math.cos(i * 0.2) * 5
        o1.move(((s.width - 50) * 0.5) + v1, 85 + v2)
        o2.move(((s.width - 50) * 0.5) - v1, 85 - v2)
      end
    end
    s.instance_variable_set("@n", n)
    def s.replace &blk
      @n.stop; @n = nil
      clear &blk
    end
    s
  end

  def clover_whoosh
    background "#efefa0"
    background "#efefa0".."#c1d5c0", :height => 150, :bottom => 150
  end

  def content
    user = HH::PREFS['username']
    clover_whoosh
    stack :margin => [10, 20, 0, 20], :width => 1.0, :height => 1.0 do
      subtitle "Your Preferences", :font => "Lacuna Regular", :margin => 0, :size => 22,
        :stroke => "#377"
      if user
        para "Hello, #{user}! ",
      else
        para "Let's set up Hackety Hack to use on the Internet okay? ",
          "Be sure you have an account from ",
          link("hackety-hack.com", :click => "http://hackety-hack.com"), "."
      end

      @prefpane =
      stack do
        stack :margin => 20, :width => 400 do
          para "Your username", :size => 10, :margin => 2, :stroke => "#352"
          @user = edit_line user, :width => 1.0

          para "Your password", :size => 10, :margin => 2, :stroke => "#352"
          @pass = edit_line HH::PREFS['password'], :width => 1.0, :secret => true

          button "Save", :margin_top => 10 do
            HH::PREFS['username'] = @user.text
            HH::PREFS['password'] = @pass.text
            HH.save_prefs
            alert("Saved, thanks!")
          end
        end
      end

    end
  end
end
