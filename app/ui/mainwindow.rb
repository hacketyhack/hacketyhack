require 'app/boot'

#require 'app/ui/tabs/home'


# methods for the main app
module HH::App
  # starts a lesson
  # returns only once the lesson gets closed
  def start_lessons name, blk
    Thread.new do
      @main_content.style(:width => -400)
      @lesson_stack.show
      HH::LessonSet.new(name, blk).execute_in @lesson_stack
      # after the lesson ends
      @lesson_stack.hide
      @main_content.style(:width => 1.0)
    end
  end

  def load_file name={}
    gettab(:Editor).load(name)
    opentab :Editor
  end
end

window :title => "Hackety Hack", :width => 790, :height => 550 do
  HH::APP = self
  extend HH::App, HH::Widgets, HH::Observable
  style(Shoes::LinkHover, :fill => nil, :stroke => "#C66")
  style(Shoes::Link, :stroke => "#377")

  @main_content = flow :width => 1.0, :height => 1.0 do
    background "#e9efe0"
    background "#e9efe0".."#c1c5d0", :height => 150, :bottom => 150
  end
  @lesson_stack = stack :hidden => true, :width => 400

  extend HH::HasSideTabs
  init_tabs @main_content
  
  addtab :Home, :icon => "tab-home.png"
  addtab :Editor, :icon => "tab-new.png"
  addtab :Console, :hover => "Try Ruby", :icon => "tab-try.png"
  addtab :Lessons, :icon => "tab-tour.png"
  addtab :Help, :icon => "tab-help.png" do
    Shoes.show_manual
  end
  addtab :Cheat, :icon => "tab-cheat.png" do
    dialog :title => "Hackety Hack - Cheat Sheet", :width => 496 do
      image "#{HH::STATIC}/hhcheat.png"
    end
  end
  addtab :About, :icon => "tab-hand.png" do
    about = app.slot.stack :top => 0, :left => 0,
                           :width => 1.0, :height => 1.0 do
      background black(0.8)
      image("#{HH::STATIC}/hhabout.png", :top => 120, :left => 0.2).
        click { about.remove }
      glossb "OK", :top => 500, :left => 0.45, :width => 70, :color => "dark" do
        about.remove
      end
      click { about.remove }
    end
  end
  addtab :Quit, :icon => "tab-quit.png", :position => :bottom do
    exit
  end
  addtab :Prefs, :hover => "Preferences", :icon => "tab-properties.png",
    :position => :bottom
  
  opentab :Home

#  # splash screen
#  stack :top => 0, :left => 0, :width => 1.0, :height => 1.0 do
#    splash
#  end
end
