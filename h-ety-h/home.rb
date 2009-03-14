module HH::Home
  def sidetab(image_src, top, name, &blk)
    v = top < 0 ? :bottom : :top
    stack v => top.abs, :left => 0, :width => 38, :margin => 4 do
      bg = background "#DFA", :height => 26, :curve => 6, :hidden => true
      image(image_src, :margin => 4).
        hover { bg.show; @tip.parent.width = 122; @tip.top = nil; @tip.bottom = nil
          @tip.send("#{v}=", top.abs); @tip.contents[1].text = name; @tip.show }.
        leave { bg.hide; @tip.hide; @tip.parent.width = 40 }.
        click &blk
    end
  end

  def home_bulletin
    stack do
      background "#FF9".."#FFF"
      subtitle "Upgrade to 0.7?", :font => "Phonetica", :align => "center", :margin => 8
      para "A New Hackety Hack is Here!", :align => "center", :margin_bottom => 50
      glossb "Upgrade", :top => 90, :left => 0.42, :width => 100, :color => "red" do
        alert("No upgrades yet.")
      end
    end
    stack do
      background black(0.4)..black(0.0)
      image 1, 10
    end
  end

  def home_arrows meth, start, total
    stack :top => 0, :right => 10 do
      nex = total > start + 5
      if start > 0
        glossb "<<", :top => 0, :right => 10 + (nex ? 100 : 0), :width => 50 do
          @homepane.clear { send(meth, start - 5) }
        end
      end
      if nex
        glossb "Next 5 >>", :top => 0, :right => 10, :width => 100 do
          @homepane.clear { send(meth, start + 5) }
        end
      end
    end
  end

  def home_scripts start = 0
    if @scripts.empty?
      para "You have no programs.", :margin_left => 12, :font => "Lacuna Regular"
    else
      @scripts[start,5].each do |script|
        stack :margin_left => 8, :margin_top => 4 do
          britelink "icon-file.png", script[:name], script[:mtime] do
            load_editor script
          end
          if script[:desc]
            para script[:desc], :stroke => "#777", :size => 9,
              :font => "Lacuna Regular", :margin => 0, :margin_left => 18,
              :margin_right => 140
          end
        end
      end
      home_arrows :home_scripts, start, @scripts.length
    end
  end

  def home_tables start = 0
    if @tables.empty?
      para "You have no tables.", :margin_left => 12, :font => "Lacuna Regular"
    else
      @tables[start,5].each do |name|
        stack :margin_left => 8, :margin_top => 4 do
          britelink "icon-table.png", name do
            alert("No tables page yet.")
          end
        end
      end
      home_arrows :home_tables, start, @tables.length
    end
  end

  def home_lessons
    para "You have no lessons.", :margin_left => 12, :font => "Lacuna Regular"
  end

  def hometab name, bg, starts = false, &blk
    tab =
      stack :margin_top => (starts ? 6 : 10), :margin_left => 14, :width => 120 do
        off = background bg, :curve => 6, :hidden => starts
        on = background rgb(233, 239, 224), :curve => (starts ? 6 : 0), :top => (starts ? 0 : 28)
        title = link(name, :stroke => (starts ? black : white), :underline => "none") do
          @tabs.each do |t|
            next unless t.contents[0].hidden
            t.margin_top = 10
            t.contents[2].contents[0].stroke = white
            t.contents[2].size = 11
            t.contents[1].style(:curve => 0, :top => 28)
            t.contents[0].show
          end
          tab.margin_top = 6
          title.stroke = black
          title.parent.size = 13
          on.style(:curve => 6, :top => 0)
          off.hide
          blk[]
        end
        para title, :size => (starts ? 13 : 11), :align => "center",
          :margin => 6, :margin_bottom => 12, :font => "Lacuna Regular"
      end
    @tabs << tab
  end

  def home
    image "#{HH::STATIC}/hhhello.png", :bottom => -120, :right => 0

    @tabs, @scripts, @tables = [], HH.scripts, HH::DB.tables
    stack :margin => 0, :margin_left => 38 do
      stack do
        background "#CDC", :height => 35
        background black(0.05)..black(0.2), :height => 38
        flow do
          hometab "Programs", "#555", true do
            @homepane.clear { home_scripts }
          end
          hometab "Lessons", "#936" do
            @homepane.clear { home_lessons }
          end
          hometab "Tables", "#799" do
            @homepane.clear { home_tables }
          end
        end
      end
      stack do
        background rgb(233, 239, 224)..rgb(233, 239, 224, 0.85)
        @homepane = stack do
          home_scripts
        end
      end
      stack :margin_left => 12 do
        background rgb(233, 239, 224, 0.85)..rgb(233, 239, 224, 0.0)
        image 10, 70
      end
      # @bulletin = stack { home_bulletin }
    end
  end
end
