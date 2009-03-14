require 'bloops'

module Kernel
  def song notes = nil, &blk
    if blk
      Song.new(&blk)
    else
      s = Song.new
      s.chord notes
      s
    end
  end
  def sound &blk
    Sound.new(&blk).sound
  end
  def instrument *a, &b
    Song.instrument(*a, &b)
  end
end

class Sound
  Bloops::Sound.instance_methods.each do |m|
    if m =~ /^(\w+)=$/
      prop = $1
      define_method(prop) do |f|
        @sound.send("#{prop}=", f)
      end
    end
  end
  attr_reader :sound
  def initialize(&blk)
    @sound = Bloops.sound 0
    instance_eval(&blk) if blk
  end
end

class Song
  @instruments = {}
  def initialize(&blk)
    @b = Bloops.new
    @b.tempo = 172
    instance_eval(&blk) if blk
  end
  def tempo t
    @b.tempo = t
  end
  def play
    @b.play
  end
  def self.instrument name, s = nil, &blk
    return if @instruments[name.to_s]
    s ||= sound(&blk)
    @instruments[name.to_s] = s
    self.send :define_method, name do |notes|
      horn = instrument name
      @b.tune horn, notes
    end
  end
  def instrument name
    Song.instance_eval { @instruments[name.to_s] }
  end

  instrument :string, (sound {
    attack 0.05; sustain 0.2; decay 0.29; square 0.22; phase 0.35
    psweep 0.25; lpf 0.43 })
  instrument :string2, (sound {
    attack 0.05; sustain 0.2; decay 0.29; phase 0.35; psweep 0.55 })

  def chord notes
    @b.tune instrument(:string), "+ #{notes}"
    @b.tune instrument(:string2), notes
  end
end

module HH::Foley
  PLAIN = Bloops.sound 0

  def foley indent = 0, &blk
    window :title => "Hackety Hack Sound Foley",
           :width => 320, :height => 620 do

      @sound = Bloops.sound Bloops::SQUARE
      @controls = {}

      def fbutton name, &blk
        stack :margin => 10, :width => 100 do
          button name, :width => 1.0, &blk
        end
      end

      def level name, prop = nil
        prop ||= name.downcase
        stack do
          p = para name, :margin => 0, :margin_left => 4, :size => 7
          flow :top => 0, :right => 0 do
            p = para "", :size => 7, :margin => 0, :align => "right", :margin_right => 4
          end
          s = slider :width => 1.0 do
            v = (s.fraction * 2.0) - 1.0
            @sound.send("#{prop}=", v)
            p.text = "%0.2f" % v
          end
          @controls[prop.to_s] = [s, p]
        end
      end
      
      def redial
        @controls.keys.each do |m|
          v = @sound.send(m)
          @controls[m][0].fraction = ((v + 1.0) * 0.5)
          @controls[m][1].text = "%0.2f" % v
        end
      end

      def newsound name
        @stype.text = name
        @msg1.margin = 0
        @msg1.hide
        @msg2.show
      end

      def make blk
        code = "  type #{@sound.type}\n"
        @controls.keys.each do |m|
          v = @sound.send(m)
          if v != PLAIN.send(m)
            code << "  %s %0.2f\n" % [m, v]
          end
        end
        blk[" do\n#{code}end"]
        close
      end

      background "#EFD".."#FED"
      stack do
        subtitle "SOUND FOLEY", :font => "pixelpoiiz", :margin => 8,
          :margin_top => 20, :align => "center", :stroke => "#BCA", :size => 28
        subtitle "SOUND FOLEY", :font => "pixelpoiiz", :top => 18, :left => 0,
          :align => "center", :margin => 0, :size => 28
        @simple = stack do
          para "What sort of sound are you looking for?", :margin => [40, 10, 40, 10],
            :align => "center"
          flow do
            fbutton "Coin" do
              newsound "Coin"
              @sound.reset
              @sound.freq = (0.4..0.9).rand
              @sound.sustain = (0.0..0.1).rand
              @sound.decay = (0.1..0.5).rand
              @sound.punch = (0.3..0.3).rand
              if rand(2) == 1
                @sound.arp = (0.2..0.4).rand
                @sound.aspeed = (0.5..0.7).rand
              end
              @sound.test
            end
            fbutton "Laser" do
              newsound "Laser"
              @sound.reset
              @sound.type = rand(3)
              if @sound.type == 2 && rand(2) == 1
                @sound.type = rand(2)
              end
              @sound.freq = (0.5..1.0).rand
              @sound.limit = @sound.freq - (0.2..0.8).rand
              @sound.limit = 0.2 if @sound.limit < 0.2
              @sound.slide = (-0.35..-0.15).rand
              if rand(3) == 0
                @sound.freq = (0.3..0.9).rand
                @sound.limit = (0.0..0.1).rand
                @sound.slide = (-0.65..-0.35).rand
              end
              if rand(2) == 1
                @sound.square = (0.0..0.5).rand
                @sound.sweep = (0.0..0.2).rand
              else
                @sound.square = (0.4..0.9).rand
                @sound.sweep = (-0.7..0.0).rand
              end
              @sound.sustain = (0.1..0.3).rand
              @sound.decay = (0.0..0.4).rand
              if rand(2) == 1
                @sound.punch = (0.0..0.3).rand
              end
              if rand(3) == 0
                @sound.phase = (0.0..0.2).rand
                @sound.psweep = (-0.2..0.0).rand
              end
              if rand(2) == 1
                @sound.freq = (0.0..0.3).rand
              end
              @sound.test
            end
            fbutton "Kablooey" do
              newsound "Kablooey"
              @sound.reset
              @sound.type = Bloops::NOISE
              if rand(2) == 1
                @sound.freq = (0.1..0.5).rand
                @sound.slide = (-0.1..0.3).rand
              else
                @sound.freq = (0.2..0.9).rand
                @sound.slide = (-0.4..-0.2).rand
              end
              @sound.freq *= @sound.freq
              if rand(5) == 0
                @sound.slide = 0.0
              end
              if rand(3) == 0
                @sound.repeat = (0.3..0.8).rand
              end
              @sound.sustain = (0.1..0.4).rand
              @sound.decay = (0.0..0.5).rand
              if rand(2) == 0
                @sound.phase = (-0.3..0.6).rand
                @sound.psweep = (0.0..0.3).rand
              end
              @sound.punch = (0.2..0.8).rand
              if rand(2) == 1
                @sound.vibe = (0.0..0.7).rand
                @sound.vspeed = (0.0..0.6).rand
              end
              if rand(2) == 0
                @sound.aspeed = (0.6..0.9).rand
                @sound.arp = (-0.8..0.8).rand
              end
              @sound.test
            end
            fbutton "1 Up" do
              newsound "1 Up"
              @sound.reset
              if rand(2) == 1
                @sound.type = Bloops::SAWTOOTH
              else
                @sound.square = (0.0..0.6).rand
              end
              @sound.freq = (0.2..0.5).rand
              if rand(2) == 1
                @sound.slide = (0.1..0.5).rand
                @sound.repeat = (0.4..0.8).rand
              else
                @sound.slide = (0.5..0.7).rand
                if rand(2) == 1
                  @sound.vibe = (0.0..0.7).rand
                  @sound.vspeed = (0.0..0.6).rand
                end
              end
              @sound.sustain = (0.0..0.4).rand
              @sound.decay = (0.1..0.5).rand
              @sound.test
            end
            fbutton "Punch" do
              newsound "Punch"
              @sound.reset
              @sound.type = rand(3)
              if @sound.type == 2
                @sound.type = 3
              end
              if @sound.type == 0
                @sound.square = (0.0..0.6).rand
              end
              @sound.freq = (0.2..0.8).rand
              @sound.slide = (-0.7..-0.3).rand
              @sound.sustain = (0.0..0.1).rand
              @sound.decay = (0.1..0.3).rand
              if rand(2) == 1
                @sound.hpf = (0.0..0.3).rand
              end
              @sound.test
            end
            fbutton "Jump" do
              newsound "Jump"
              @sound.reset
              @sound.square = (0.0..0.6).rand
              @sound.freq = (0.3..0.6).rand
              @sound.slide = (0.1..0.3).rand
              @sound.sustain = (0.1..0.4).rand
              @sound.decay = (0.1..0.3).rand
              if rand(2) == 1
                @sound.hpf = (0.0..0.3).rand
              end
              if rand(2) == 1
                @sound.lpf = (0.4..1.0).rand
              end
              @sound.test
            end
            fbutton "Select" do
              newsound "Select"
              @sound.reset
              @sound.type = rand(2)
              if @sound.type == 0
                @sound.square = (0.0..0.6).rand
              end
              @sound.freq = (0.2..0.6).rand
              @sound.sustain = (0.1..0.2).rand
              @sound.decay = (0.0..0.2).rand
              @sound.hpf = 0.1
              @sound.test
            end
          end
          stack :margin => 20 do
            background black(0.2), :curve => 12
            @msg1 = stack :margin => 6 do
              para "The new sound will appear here.", :margin => 0
            end
            @msg2 = stack :margin => 6, :hidden => true do
              @stype = strong("Coin")
              para "Okay, a random ", @stype, " sound has been made.", :margin => 0
              flow :width => 260 do
                button "Play Again" do
                  @sound.test
                end
                button "Edit" do
                  @simple.hide
                  @advanced.show
                  redial
                  timer 0.1 do
                    redial
                  end
                end
                button "Save" do
                  make blk
                end
              end
            end
          end
        end
        # list_box :items => ['Square', 'Sawtooth', 'Sinewave', 'Noise'],
        #   :choose => 'Square'
        @advanced = stack :hidden => true do
          flow do
            stack :width => 0.45, :margin_left => 0.05 do
              stack :margin => 6 do
                level "VOLUME"
                level "PUNCH"
                level "ATTACK"
                level "SUSTAIN"
                level "DECAY"
              end
              stack :margin => 6 do
                level "FREQUENCY", :freq
                level "LIMIT"
                level "SLIDE"
                level "DELTA SLIDE", :dslide
              end
              stack :margin => 6 do
                level "VIBRATO", :vibe
                level "VIBE SPEED", :vspeed
                level "VIBE DELAY", :vdelay
              end
            end
            stack :width => 0.45, :margin_left => 0.05 do
              stack :margin => 6 do
                level "SQUARE"
                level "SWEEP"
              end
              stack :margin => 6 do
                level "LO-PASS FILTER", :lpf
                level "LO SWEEP", :lsweep
                level "RESONANCE"
                level "HI-PASS FILTER", :hpf
                level "HI SWEEP", :hsweep
              end
              stack :margin => 6 do
                level "ARP"
                level "ARP SPEED", :aspeed
                level "PHASE"
                level "PHASE SWEEP", :psweep
                level "REPEAT"
              end
            end
          end
          flow :width => 260, :margin_left => 40 do
            button "Back" do
              @advanced.hide
              @simple.show
            end
            button "Play" do
              @sound.test
            end
            button "Save" do
              make blk
            end
          end
        end
      end
    end
  end
end
