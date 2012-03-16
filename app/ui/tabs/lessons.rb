module Kernel
  # topmost instruction for the lessons DSL
  # starts a lesson set
  def lesson_set name, &blk
    HH::SideTabs::Lessons.load_lesson name, blk
  end
end

class HH::SideTabs::Lessons < HH::SideTab
  # auxiliary function used by Kernel#lesson_set
  # stores the code of the DSL used to write the lessons
  def self.load_lesson name, blk
    @@lessons << [name, blk]
  end

  # draws the lessons tab
  def content
    stack :margin => 10 do
      title "Lessons"
      @@lessons = []
      Dir["#{HH::LESSONS}/*.rb"].each { |f| load f }

      %w[beginner intermediate advanced expert].each do |d|
        @@difficulty = d.capitalize
        Dir["#{HH::LESSONS}/#{d}/*.rb"].each { |f| load f }
      end

      @@lessons.sort_by{|lesson| lesson[0]}.each do |lesson|
        stack do
          britelink "icon-file.png", lesson[0] do
            HH::APP.start_lessons lesson[0], lesson[1]
          end
        end
      end
    end
  end
end

