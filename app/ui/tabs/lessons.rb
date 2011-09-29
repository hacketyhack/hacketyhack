class HH::SideTabs::Lessons < HH::SideTab
  # draws the lessons tab
  def content
    stack :margin => 10 do
      title "Lessons", :font => "Phonetica"
      para "So you want to learn some programming, eh? You've come to the right place!"

      lessons_by_level = {}

      lessons_by_level['About Hackety'] = []
      Dir["#{HH::LESSONS}/*.md"].each do |f|
        lessons_by_level['About Hackety'].push f
      end

      %w[beginner intermediate advanced expert].each do |level|
        lessons_by_level[level.capitalize] = []
        Dir["#{HH::LESSONS}/#{level}/*.md"].each do |f|
          lessons_by_level[level.capitalize].push f
        end
      end

      title_getter = HH::LessonTitleGetter.new
      markdown = Redcarpet::Markdown.new(title_getter)
      
      lessons_by_level.each do |level, lesson_files|
        unless lesson_files.empty?
          para level
          lesson_files.each do |lesson_file|
            src = File.read(lesson_file)
            markdown.render(src)
            lesson_title = title_getter.title
            
            stack do
              britelink "icon-file.png", lesson_title do
                HH::APP.start_lesson_set(lesson_file)
              end
            end
          end
        end
      end
    end
  end
end

class HH::LessonTitleGetter < Redcarpet::Render::Base

  attr_reader :title

  def header(text, level)
    @title = text if level == 1
  end
  
end
