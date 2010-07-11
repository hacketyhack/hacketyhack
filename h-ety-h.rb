#!/usr/bin/env shoes

# the main application executable

require 'h-ety-h/boot'
require 'h-ety-h/home'
require 'h-ety-h/prefs'

window :title => "Hackety Hack", :width => 575, :height => 700 do
  HH::APP = self
  extend HH::Widgets, HH::Home
  style(Shoes::LinkHover, :fill => nil, :stroke => "#C66")
  style(Shoes::Link, :stroke => "#377")

  background "#e9efe0"
  background "#e9efe0".."#c1c5d0", :height => 150, :bottom => 150

  @action =
    stack :top => 0, :left => 0, :width => 1.0, :height => 1.0 do
      home
    end

  # auxiliary method to load the editor
  def load_editor name = {}
    # the editor methods are included the first time
    unless respond_to? :editor
      require 'h-ety-h/editor'
      extend HH::Editor
    end
    @action.clear { editor(name) }
  end

  stack :top => 0, :left => 0, :width => 40, :height => 1.0 do
    @tip = stack :top => 0, :left => 0, :width => 120, :margin => 4, :hidden => true do
      background "#F7A", :curve => 6
      para "HOME", :margin => 3, :margin_left => 40, :stroke => white
    end
    # colored background
    background "#cdc", :width => 38
    background "#dfa", :width => 36
    background "#fda", :width => 30
    background "#daf", :width => 24
    background "#aaf", :width => 18
    background "#7aa", :width => 12
    background "#77a", :width => 6
    sidetab "#{HH::STATIC}/tab-home.png", 0, "HOME" do
      @action.clear { home }
    end
    sidetab "#{HH::STATIC}/tab-new.png", 32, "NEW" do
      load_editor
    end    
    sidetab "#{HH::STATIC}/tab-try.png", 64, "TRY RUBY!" do
      # the console methods are included the first time
      unless respond_to? :console
        require 'h-ety-h/console'
        extend HH::Console
      end
      @action.clear { console }
    end
    sidetab "#{HH::STATIC}/tab-help.png", 96, "HELP" do
      Shoes.show_manual
    end
    sidetab "#{HH::STATIC}/tab-cheat.png", 128, "CHEAT" do
      dialog :title => "Hackety Hack - Cheat Sheet", :width => 496 do
        image "#{HH::STATIC}/hhcheat.png"
      end
    end
    sidetab "#{HH::STATIC}/tab-hand.png", 160, "ABOUT" do
      about =
        app.slot.stack :top => 0, :left => 0, :width => 1.0, :height => 1.0 do
          background black(0.8)
          image("#{HH::STATIC}/hhabout.png", :top => 120, :left => 0.2).
            click { about.remove }
          glossb "OK", :top => 500, :left => 0.45, :width => 70, :color => "dark" do
            about.remove
          end
          click { about.remove }
        end
    end
    sidetab "#{HH::STATIC}/tab-email.png", -74, "INBOX" do
      unless respond_to? :prefs
        require 'h-ety-h/prefs'
        extend HH::Prefs
      end
      @action.clear { prefs }
    end
    sidetab "#{HH::STATIC}/tab-quit.png", -42, "QUIT" do
      exit
    end
  end

  @notice =
  stack :bottom => 33, :left => 22, :width => 160, :height => 54, :hidden => true do
    fill black(0.6)
    nostroke
    shape 0, 20 do
      line_to 23.6, 0
      line_to 23.6, 10
      line_to 0, 0
    end
    background black(0.6), :curve => 6, :left => 24, :width => 136
    para "You have ", @noticeN = strong("0 new"), " messages.",
      :stroke => "#FFF", :margin => 6, :size => 11, :margin_left => 24,
      :align => "center"
  end

  @mailcheck =
    every 20 do
      if HH.user
				HH.user.update_programs do |programs|
				  unless  programs['programs'].nil?
				    debug("programs count: #{programs['programs'].count}")
  					programs = programs['programs']
  					programs.each do |program|
  						name = program['name'].gsub(/ /, '_')
  						unless HH.script_exists?(name)
  							HH.save_script(name, program['text'])
  						end
  					end
  				end
				end
				if @notice.hidden == true
					HH.user.get_inbox_count do |c|
						unless c['messages'].nil?
					  	count = c['messages'].select{|m| m['read'] == false}.length
  						if(count > 0)
  							@noticeN.text = "#{count} new"
  							@notice.show
  							@mailcheck.stop
  						end
  					end
					end
				end
      end
    end

  # splash screen
  stack :top => 0, :left => 0, :width => 1.0, :height => 1.0 do
    splash
  end
end
