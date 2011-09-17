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
                HH::APP.start_lessons lesson
              end
            end
          end
        end
      end

      @@lessons = []
      @@difficulty = "About Hackety"
      Dir["#{HH::LESSONS}/*.rb"].each { |f| load f }

      %w[beginner intermediate advanced expert].each do |d|
        @@difficulty = d.capitalize
        Dir["#{HH::LESSONS}/#{d}/*.rb"].each { |f| load f }
      end

      # group_by difficulty
      @@lessons.group_by{|i| i[0]}.each do |key, value|
        para key.to_s
        value.each do |v|
          stack do
            britelink "icon-file.png", v[1] do  # v[1] = lesson_set name, from the lesson ruby files (or the Markdown h1)
              HH::APP.start_lessons_dsl v[1], v[2] # v[2] = the lesson_set block - the body of the lesson.
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

  def codespan(src)
    @current_page.add_action { code(src) }
    ''
  end

  def block_code(src, language) # TODO do something useful w/ language, like add 'run now'
    @current_page.add_action { embed_code(src) }
    ''
  end

  def image(link, title, alt_text)

    block = if alt_text.nil? || alt_text.empty?
              lambda {}
            else
              lambda { alert(alt_text) }
            end

    @current_page.add_action do
      icon_button(link.to_sym, nil, &block)
    end
    ''
  end
end

<<WHAT_SHOULD_WE_WRITE
From Markdown:
  block_code(code, language)
  block_quote(quote)
  block_html(raw_html)
  header(text, header_level)
  hrule()
  list(contents, list_type)
  list_item(text, list_type)
  paragraph(text)
  table(header, body)
  table_row(content)
  table_cell(content, alignment)

  autolink(link, link_type)
  codespan(code)
  double_emphasis(text)
  emphasis(text)
  image(link, title, alt_text)
  linebreak()
  link(link, title, content)
  raw_html(raw_html)
  triple_emphasis(text)
  strikethrough(text)
  superscript(text)

  entity(text)
  normal_text(text)


From the DSL:
    lesson_set name
    lesson name
    page name
  flow
    para *lines
    em text
  strong text
  icon_button(name_symbol, not_sure_but_is_nil, &block)
  alert(txt)
  image(path, opts={}, &block)
  next_when(tab_opened, tab_name)
    embed_code(code, opts={})
  link(text, opts={})
    code(text)
WHAT_SHOULD_WE_WRITE
