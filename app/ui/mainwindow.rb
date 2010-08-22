require 'app/boot'


# methods for the main app
module HH::App
  # starts a lesson
  # returns only once the lesson gets closed
  include HH::Markup
  def start_lessons name, blk
      @main_content.style(:width => -400)
      @lesson_stack.show
      l = HH::LessonSet.new(name, blk).execute_in @lesson_stack
      l.on_event :close do hide_lesson end
  end

  def hide_lesson
    @lesson_stack.hide
    @main_content.style(:width => 1.0)
  end

  def load_file name={}
    if gettab(:Editor).load(name)
      opentab :Editor
    end
  end

  # replaces the "Running..." message of the currently running program
  def say arg
    # FIXME TODO: DECOMMENT TO REPRODUCE A SEGMENTATION FAULT: para (para "abc")
    if @program_running
      txt = case arg
      when String
        arg
      else
        highlight(txt.inspect)
      end
      @program_running.clear{para txt}
    end
  end

  def finalization
    # this gets called on close
    HH::LessonSet.close_open_lesson
    gettab(:Editor).save_if_confirmed

    HH::PREFS['width'] = width
    HH::PREFS['height'] = height
    HH::save_prefs
  end
end

w = (HH::PREFS['width'] || '790').to_i
h = (HH::PREFS['height'] || '550').to_i
window :title => "Hackety Hack", :width => w, :height => h do
  HH::APP = self
  extend HH::App, HH::Widgets, HH::Observable
  style(Shoes::LinkHover, :fill => nil, :stroke => "#C66")
  style(Shoes::Link, :stroke => "#377")

  @main_content = flow :width => 1.0, :height => -1 do
    background "#e9efe0"
    background "#e9efe0".."#c1c5d0", :height => 150, :bottom => 150
  end
  @lesson_stack = stack :hidden => true, :width => 400
  @lesson_stack.finish do
    finalization
  end

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
    close
  end
  addtab :Prefs, :hover => "Preferences", :icon => "tab-properties.png",
    :position => :bottom
  
  opentab :Home

#  # splash screen
#  stack :top => 0, :left => 0, :width => 1.0, :height => 1.0 do
#    splash
#  end
end
