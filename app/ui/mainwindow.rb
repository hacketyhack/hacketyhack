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

#  # auxiliary method to load the editor
#  def load_editor name = {}
#    # the editor methods are included the first time
#    unless respond_to? :editor
#      require 'app/ui/tabs/editor'
#      extend HH::Editor
#    end
#    @action.clear { editor(name) }
#  end




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

#  @action = stack :margin_left => 38, :height => 1.0 do
#    home
#  end
#
#  @lesson_stack = stack :hidden => true, :width => 400
#
#  # declared after the main content because that way hover text
#  # gets displayed on top
#  stack :top => 0, :left => 0, :width => 38, :height => 1.0 do
#    @tip = stack :top => 0, :left => 0, :width => 120, :margin => 4, :hidden => true do
#      background "#F7A", :curve => 6
#      para "HOME", :margin => 3, :margin_left => 40, :stroke => white
#    end
#    # colored background
#    background "#cdc", :width => 38
#    background "#dfa", :width => 36
#    background "#fda", :width => 30
#    background "#daf", :width => 24
#    background "#aaf", :width => 18
#    background "#7aa", :width => 12
#    background "#77a", :width => 6
#    sidetab "#{HH::STATIC}/tab-home.png", 0, "HOME" do
#      @action.clear { home }
#    end
#    sidetab "#{HH::STATIC}/tab-new.png", 32, "NEW" do
#      load_editor
#    end
#    sidetab "#{HH::STATIC}/tab-try.png", 64, "TRY RUBY!" do
#      # the console methods are included the first time
#      unless respond_to? :console
#        require 'app/ui/tabs/console'
#        extend HH::Console
#      end
#      @action.clear { console }
#    end
#    sidetab "#{HH::STATIC}/tab-tour.png", 96, "LEARN" do
#      unless respond_to? :prefs
#        require 'app/ui/tabs/lessons'
#        extend HH::LessonTab
#      end
#      @action.clear { lesson_tab }
#      # start_lessons
#    end
#    sidetab "#{HH::STATIC}/tab-help.png", 128, "HELP" do
#      Shoes.show_manual
#    end
#    sidetab "#{HH::STATIC}/tab-cheat.png", 160, "CHEAT" do
#      dialog :title => "Hackety Hack - Cheat Sheet", :width => 496 do
#        image "#{HH::STATIC}/hhcheat.png"
#      end
#    end
#    sidetab "#{HH::STATIC}/tab-hand.png", 192, "ABOUT" do
#      about =
#        app.slot.stack :top => 0, :left => 0, :width => 1.0, :height => 1.0 do
#          background black(0.8)
#          image("#{HH::STATIC}/hhabout.png", :top => 120, :left => 0.2).
#            click { about.remove }
#          glossb "OK", :top => 500, :left => 0.45, :width => 70, :color => "dark" do
#            about.remove
#          end
#          click { about.remove }
#        end
#    end
#    sidetab "#{HH::STATIC}/tab-properties.png", -74, "INBOX" do
#      unless respond_to? :prefs
#        require 'app/ui/tabs/prefs'
#        extend HH::Prefs
#      end
#      @action.clear { prefs }
#    end
#    sidetab "#{HH::STATIC}/tab-quit.png", -42, "QUIT" do
#      exit
#    end
#  end
#
#  # splash screen
#  stack :top => 0, :left => 0, :width => 1.0, :height => 1.0 do
#    splash
#  end
end
