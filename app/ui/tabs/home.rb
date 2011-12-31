# the home tab content

class HH::SideTabs::Home < HH::SideTab
  def home_bulletin(new_version)
    @bulletin_stack.clear do
      stack do
        background "#FF9"
        subtitle "Upgrade to #{new_version}!", :font => "Phonetica", :align => "center", :margin => 8
        para "A New Hackety Hack is Here!", :align => "center"
        para "Go to ", link("hackety-hack.com", :click => "http://hackety-hack.com/download"), " to get it!", :align => "center", :margin_bottom => 20
      end
    end
  end
  def initialize *args, &blk
    super *args, &blk
    # never changes so is most efficient to load here
    @samples = HH.samples
    if Web.internet_connection?
      Upgrade::check_latest_version do |version| 
        home_bulletin(version['version']) if version['version'] != HH::VERSION
      end
    end
  end

  # auxiliary method to displays the arrows, for example in case
  # more than 5 programs have to be listed
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


  def home_scripts start=0
    display_scripts @scripts, start
  end

  def sample_scripts start=0
    display_scripts @samples, start, true
  end

  # auxiliary function used to both display the user programs (scripts)
  # and the samples
  def display_scripts scripts, start, samples = false
    if scripts.empty?
      para "You have no programs.", :margin_left => 12, :font => "Lacuna Regular"
    else
      scripts[start,5].each do |script|
        stack :margin_left => 8, :margin_top => 4 do
          flow do
            britelink "icon-file.png", script[:name], script[:mtime] do
              load_file script
            end
            unless script[:sample]
              # if it is not a sample file
              para (link "x" do
                if confirm("Do you really want to delete \"#{script[:name]}\"?")
                  delete script
                end
              end)
            end
          end
          if script[:desc]
            para script[:desc], :stroke => "#777", :size => 9,
              :font => "Lacuna Regular", :margin => 0, :margin_left => 18,
              :margin_right => 140
          end
        end
      end
      # FIXME: sometimes :sample_scripts
      m = samples ? :sample_scripts : :home_scripts
      home_arrows m, start, scripts.length
    end
  end

  def delete script
    File.delete "#{HH::USER}/#{script[:name]}.rb"
    reset
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

  def on_click
    reset
  end

  # creates the content of the home tab
  def content
    image "#{HH::STATIC}/hhhello.png", :bottom => -120, :right => 0

    @tabs= []
    @scripts = HH.scripts
    stack :margin => 0, :margin_left => 0 do
      stack do
        background "#CDC", :height => 35
        background black(0.05)..black(0.2), :height => 38
        flow do
          hometab "Programs", "#555", true do
            @homepane.clear { home_scripts }
          end
          hometab "Samples", "#555", false do
            @homepane.clear { sample_scripts }
          end
        end
      end
      stack do
        @homepane = stack do
          home_scripts
        end
      end
      stack :margin_left => 12 do
        background rgb(233, 239, 224, 0.85)..rgb(233, 239, 224, 0.0)
        image 10, 70
      end
      @bulletin_stack = stack do
      end
    end
  end
end
