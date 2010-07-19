lesson_set "Proof of Concept" do
  lesson "The first lesson"
  page "First page of the first lesson" do
    para "Okay let's start this lesson\n", :stroke => white
    @p = para "type something in the console to replace",
      " this text with exclamation marks", :stroke => white
    @c = on_event :try_ruby_command, :any, :any, String do
      @p.replace "!!!!!!!!!!!!!!!!!!!!!!!!\n" +
        "now execute code that returns an array"
      delete_event_connection @c
      next_when :try_ruby_command, :any, Array, :any
    end
  end
  page "Second page" do
    para "content of the second page of the first lesson", :stroke => white
  end

  lesson "A bit more in depth"
  page "Start lesson 2" do
    para "this lesson has only one page...", :stroke => white
  end
  
  lesson "Third Lesson"
  page "third lesson lesson" do
    para "This is the third lesson", :stroke => white
  end
  page "still third lesson" do
    para "here is another page", :stroke => white
  end
  page "still third lesson" do
    para "and here is one more page", :stroke => white
    para "with two paras", :stroke => white
  end
end
