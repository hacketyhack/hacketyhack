# some methods to allow the user to play sounds

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
