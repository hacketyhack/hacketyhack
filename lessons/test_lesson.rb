lesson_set "Proof of Concept" do
  init do
    EXCLAMATION = "!!!!!!!! !!!!!!!! !!!!!!!!"
  end

  lesson "The first lesson"
  page "First page of the first lesson" do
    para "Okay let's start this lesson\n"
    @p = para "type something in the console to replace",
      " this text with exclamation marks ", link("a random link....")
    @c = on_event :try_ruby_command, {} do
      @p.replace "#{EXCLAMATION}\n" +
        "now execute code that returns an array"
      delete_event_connection @c
      next_when :try_ruby_command, :answer => Array
    end
  end
  page "Second page" do
    para "content of the second page of the first lesson"
  end

  lesson "A bit more in depth"
  page "Start lesson 2" do
    para "this lesson has only one page..."
  end
  
  lesson "Third Lesson"
  page "third lesson lesson" do
    para "This is the third lesson"
  end
  page "still third lesson" do
    para "here is another page"
  end
  page "still third lesson" do
    para "and here is one more page"
    para "with two paras"
  end
end
