class HH::SideTabs::Lessons < HH::SideTab
  # draws the lessons tab
  def content
    stack :margin => 10 do
      title "Lessons", :font => "Phonetica"
      para "So you want to learn some programming, eh? You've come to the right place!"

      lesson_sets = {}

      lesson_sets['About Hackety'] = []
      Dir["#{HH::LESSONS}/*.md"].each do |f|
        lesson_set = mark_up(f)
        lesson_sets['About Hackety'].push lesson_set
      end

      %w[beginner intermediate advanced expert].each do |difficulty|
        lesson_sets[difficulty.capitalize] = []
        Dir["#{HH::LESSONS}/#{difficulty}/*.md"].each do |f|
          lesson_set = mark_up(f)
          lesson_sets[difficulty.capitalize].push lesson_set
        end
      end

      lesson_sets.each do |difficulty, lessons|
        unless lessons.empty?
          para difficulty
          lessons.each do |lesson|
            stack do
              britelink "icon-file.png", lesson.name do
                HH::APP.start_lesson_set lesson
              end
            end
          end
        end
      end
    end
  end

  def mark_up(f)
    mdp = MDP.new
    md = Redcarpet::Markdown.new(mdp)
    src = File.read(f)
    md.render(src)
    return mdp.lesson_set
  end
end

class MDP < Redcarpet::Render::Base
  attr_reader :lesson_set

  def header(text, level)
    case level
    when 1
      @lesson_set = HH::LessonSet.new(text)
    when 2
      @lesson_set.add_lesson(text)
    when 3
      @current_page = @lesson_set.add_page(text)
    end
    ''
  end

  def paragraph(text)
    @current_page.add_action { para(text) }
    ''
  end

  def emphasis(text)
    @current_page.add_action { em(text) }
    ''
  end

  def double_emphasis(text)
    @current_page.add_action { strong(text) }
    ''
  end

  def codespan(src)
    @current_page.add_action { code(src) }
    ''
  end

  # TODO do something useful w/ language, like add 'run now'
  def block_code(src, language)
    @current_page.add_action { embed_code(src) }
    ''
  end

  def image(path, title, alt_text)

    # HH::STATIC  ->  HH::HOME + "/static"  ->  Dir.pwd + "/static"
    # HH::STATIC                 -> /home/dan/projects/hacketyhack/static
    # #{HH::STATIC}/tab-home.png -> /home/dan/projects/hacketyhack/static/tab-home.png

    # This is a good example of the kind of necessary-muck I want to minimize.
    block = if alt_text.nil? || alt_text.empty?
              Proc.new {}
            else
              Proc.new { alert(alt_text) }
            end

    if path.start_with? "/icon_button/"
      path.sub! '/icon_button/', ''
      @current_page.add_action do
        icon_button(path.to_sym, nil, &block)
      end

    else
      path = File.join(HH::HOME, path)  # TODO unless it's a URL
      @current_page.add_action do
        image(path, {}, &block)
      end
    end

    ''
  end
end
