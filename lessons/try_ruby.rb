lesson_set "Try Ruby" do
  init do
    S = " " * 10
    POEM = "My toast has flown from my hand\n" +
           "And my toast has gone to the moon.\n" +
           "But when I saw it on television,\n" +
           "Planting our flag on Halley's comet,\n" +
           "More still did I wish to munch it.\n"
  end
  

  lesson "The basics"

  page "Okay, Let's Do This" do
    para "The purplish-red window above is a Ruby prompt. Type a little bit of code, press ",
        em("Enter"), " and watch it go. Nothing to it."
    para "For example, try typing some math. Like: ",
        prompt("2 + 6")
    next_when :try_ruby_command, :code => /\+|\-|\/|\*/, :answer => Fixnum
  end

  page "Second page" do
    para "hooray!! the first page is done :)"
  end
end