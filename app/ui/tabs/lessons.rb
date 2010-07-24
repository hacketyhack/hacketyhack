module Kernel
  # topmost instruction for the lessons DSL
  # starts a lesson set
  def lesson_set name, &blk
    HH::LessonTab.load_lesson name, blk
  end
end

module HH::LessonTab
  # auxiliary function used by Kernel#lesson_set
  # stores the code of the DSL used to write the lessons
  def self.load_lesson name, blk
    @@lessons << [name, blk]
  end

  # starts a lesson
  # returns only once the lesson gets closed
  def start_lessons name, blk
    Thread.new do
      @action.style(:width => -400)
      @lesson_stack.show
      HH::LessonSet.new(name, blk).execute_in @lesson_stack
      # after the lesson ends
      @lesson_stack.hide
      @action.style(:width => 1.0)
    end
  end

  # draws the lessons tab
  def lesson_tab
    stack :margin => 10 do
      title "Lessons"
      @@lessons = []
      Dir["#{HH::LESSONS}/*.rb"].each { |f| load f }
      @@lessons.each do |name, blk|
        stack do
          britelink "icon-file.png", name do
            start_lessons name, blk
          end
        end
      end
    end
  end
end

