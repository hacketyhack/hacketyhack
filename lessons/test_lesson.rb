lesson_set "Test Lesson" do
  lesson "The first lesson"
  page "First page of the first lesson" do
    para "Okay let's start this lesson", :stroke => white
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
