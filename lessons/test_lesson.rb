lesson_set "test lesson" do
  lesson 1
  page "Page Name" do
    para "content of the first page", :stroke => white
  end
  page "Les 1 page 2" do
    para "content of the second page", :stroke => white
  end
  lesson 2
  page "Start lesson 2" do
    para "this lesson has only one page", :stroke => white
  end
end
