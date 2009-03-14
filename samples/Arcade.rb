window do
  background red
  @h = dingbat("Arcade:66", :stroke => white, :size => 120)

  keypress do |k|
    case k
    when :right
      @h.tween :sideways => 120
    when :up
      @h.tween :downward => -120
    when :left
      @h.tween :sideways => -120
    when :down
      @h.tween :downward => 120
    end
  end
end