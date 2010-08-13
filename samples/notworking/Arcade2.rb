jump = sound do
  type 0
  sustain 0.33
  decay 0.21
  freq 0.41
  hpf 0.07
  slide 0.17
  square 0.05
end

drink = sound do
  type 0
  sustain 0.36
  decay 0.32
  repeat 0.47
  freq 0.21
  slide 0.14
  square 0.50
end

window do
  background red
  @h = dingbat("Arcade:66", :stroke => white, :size => 80)
  @m = dingbat("Fontalicious:68", :hidden => true, :stroke => brown)

  def @m.rand
    move((0..4).rand * 120,
         (0..4).rand * 120).show
  end

  keypress do |k|
    case k
    when :right
      if @h.left < @m.left and @h.left + 140 >= @m.left
        drink.test
        @m.hide
      end
      @h.tween :sideways => 120
    when :up
      @h.tween :downward => -120
      jump.test
    when :left
      @h.tween :sideways => -120
    when :down
      @h.tween :downward => 120
    end
  end

  start do
    @m.rand
  end
end