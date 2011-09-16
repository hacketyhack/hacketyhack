# TODO get rid of this top-level of indirection, mucking with Kernel. We can just load via markdown-y stuff.
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
    @@lessons << [@@difficulty, name, blk]
  end

  # draws the lessons tab
  def content
    stack :margin => 10 do
      title "Lessons", :font => "Phonetica"
      @@lessons = []
      @@difficulty = "About Hackety"
      para "So you want to learn some programming, eh? You've come to the right place!"
      Dir["#{HH::LESSONS}/*.rb"].each { |f| load f }
      Dir["#{HH::LESSONS}/*.md"].each { |f| mark_up f }

      %w[beginner intermediate advanced expert].each do |d|
        @@difficulty = d.capitalize
        Dir["#{HH::LESSONS}/#{d}/*.rb"].each { |f| load f }
        Dir["#{HH::LESSONS}/#{d}/*.md"].each { |f| mark_up f }
      end

      # group_by difficulty
      @@lessons.group_by{|i| i[0]}.each do |key, value|
        para key.to_s
        value.each do |v|
          stack do
            britelink "icon-file.png", v[1] do  # v[1] = lesson_set name, from the lesson ruby files (or the Markdown h1)
              HH::APP.start_lessons v[1], v[2] # v[2] = the lesson_set block - the body of the lesson.
                                                # name = 'Hackety Hack'
            end
          end
        end
      end
    end
  end
  
  def mark_up(f)
    src = File.read(f)
    puts "read #{f}"
  end
end



