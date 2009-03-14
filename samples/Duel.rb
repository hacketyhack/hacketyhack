waists = ["<|\\/|>\n",
          "<|--|>\n",
          "<|/\\|>\n"]
legs = ["/ \\/ \\",
        " |\\ |\\"]
insults = ["You shriveled\nsack of donuts!",
           "En guarde,\nvile hound!",
           "\nUncouth!",
           "Nice going,\n Gus!",
           "Your fly\nis down.",
           "Get away,\ncurs-ed janitor!"]

window :width => 400, :height => 400 do
  background black

  @swords = stack :top => 80, :left => 0 do
    para @insult = span("\n\n"),
      :font => "Lacuna",
      :stroke => white, :size => 14, :margin => 0
    para "~o  o~\n",
       @waist = span("<|\\/|>\n"),
       @leg = "/ \\/ \\", :font => "Liberation Mono",
          :stroke => white, :size => 24
  end

  animate do |i|
    if i % 30 == 0
      @insult.replace(insults[(0..insults.length).rand],
        (i % 60) == 0 ? "\n      /" : "\n             \\")
    end

    @waist.replace waists[i % 3]
    @leg.replace legs[i % 2]
    x = (Math.sin(i * 0.22) * 100) + 140
    @swords.left = x.to_i
  end
end