module Kernel
  def lesson_set name, &blk
    HH::LessonTab.load_lesson name, blk
  end
end

module HH::LessonTab
  def self.load_lesson name, blk
    @@lessons << [name, blk]
  end

  # returns only once the lesson gets closed
  def start_lessons blk # lessons_name
    Thread.new(Thread.current) do |parent|
      begin
        @action.style(:width => -400)
        @lesson_stack.show
        HH::LessonSet.new(blk).execute_in @lesson_stack
        # after the lesson ends
        @lesson_stack.hide
        @action.style(:width => 1.0)
      rescue => ex
        error ex
      end
    end
  end
  
  def lesson_tab
    stack :margin => 10 do
      title "Lessons"
      @@lessons = []
      Dir["#{HH::LESSONS}/*.rb"].each { |f| load f }
      stack do
        @@lessons.each do |name, blk|
          britelink "icon-file.png", name, Time.now do
            start_lessons blk
          end
        end
      end
    end
  end
end

