# Sword fight.
window :width => 400, :height => 400 do
  background black

  @swords = stack :top => 80, :left => 0 do
    para "~o  o~\n",
       "<|\\/|>\n",
       "/ \\/ \\", :font => "Monospace",
          :stroke => white, :size => 24
  end

  animate do |i|
    x = (Math.sin(i * 0.22) * 100) + 140
    @swords.left = x.to_i
  end
end