
# redefines methods, like title and para, for use in the lessons
# included in HH::LessonContainer
module HH::LessonContainerText
  TITLES = {:font => "Lacuna Regular", :stroke => "#e06", :margin => 4}
  PARAS = {:stroke => "#eec", :size => 11, :margin_bottom => 6}
  LIST = {:margin_left => 20, :margin => 4, :size => 10}
  CODE_STYLE = {:size => 9, :margin => 8, :font => "Liberation Mono",
    :stroke => "#000"}
  COLORS = {
    :comment => {:stroke => "#bba"},
    :keyword => {:stroke => "#FCF90F"},
    :method => {:stroke => "#C09", :weight => "bold"},
    :symbol => {:stroke => "#9DF3C6"},
    :string => {:stroke => "#C9F5A5"},
    :number => {:stroke => "#C9F5A5"},
    :regex => {:stroke => "#000", :fill => "#FFC" },
    :attribute => {:stroke => "#C9F5A5"},
    :expr => {:stroke => "#f33" },
    :ident => {:stroke => "#6e7"},
    :any => {:stroke => "#FFF"},
    :constant => {:stroke => "#55f", :weight => "bold"},
    :class => {:stroke => "#55f", :weight => "bold"},
    :matching => {:stroke => "#f00", :weight => "bold"},
  }

  # merges options +opts+ with those of +args+ if any
  def merge_opts(args, opts)
    res = args.dup
    if res.last.is_a? Hash
      # there are already options
      # keep them
      orig_opts = res.last
      orig_opts.replace(opts.merge(orig_opts))
    else
      res << opts
    end
    res
  end

  def title *args
    super *merge_opts( args, TITLES.merge(:size => 22) )
  end
  def subtitle *args
    super *merge_opts( args, TITLES.merge(:size => 14) )
  end
  def item *args
    para *merge_opts( args, LIST )
  end
  def para *args
    super *merge_opts( args, PARAS )
  end
  # FileUtils.link gets precedence else, i don't quite understand why that
  # module is included at all but it is...
  def link *a, &b; app.link *a, &b end
  def code *args
    super *merge_opts( args, {:stroke => "#9de", :fill => "#237"} )
  end
  def prompt *args
    code *merge_opts( args, {:stroke => "#EEE", :fill => "#602"} )
  end

  include HH::Markup
  def embed_code str, opts={}
    stack :margin_bottom => 12 do
      background "#602", :curve => 4
      para highlight(str, nil, COLORS), CODE_STYLE
      if opts[:run_button]
        stack :top => 0, :right => 2, :width => 70 do
          stack do
            background "#8A7", :margin => [0, 2, 0, 2], :curve => 4
            l = link("Run this", :stroke => "#eee", :underline => "none") do
              eval(str, TOPLEVEL_BINDING)
            end
            para l, :margin => 4, :align => 'center',
              :weight => 'bold', :size => 9
          end
        end
      end
    end
  end
end



# the code in the +page+ blocks in the lessons is executed with +self+
# being a LessonEnvironment, methods of the main app (and thus of shoes):
# method_missing propagates all calls
class HH::LessonContainer
  include HH::LessonContainerText

  # the Shoes slot that contains the lesson
  attr_accessor :slot

  def initialize lesson_set
    @lesson_set = lesson_set
    @event_connections = []
  end

  # convenience method the access the main shoes application
  def app
    @slot.app
  end

  def method_missing(symbol, *args, &blk)
    app.send symbol, *args, &blk
  end

  # part of the lesson DSL, executes the page block
  def set_content &blk
    delete_event_connections
    @slot.clear { instance_eval &blk }
  end

  def on_event *args, &blk
    conn = app.on_event(*args, &blk)
    @event_connections << conn
    conn
  end

  # on the event specified in +args+ goes to the next page
  # if a block is specified it is used as additional condition
  # the event arguments are passed to the block
  def next_when *args, &blk  # This is ONLY ever used for :tab_opened, and we never pass a block
    if blk
      unless args.size == 1
        raise ArgumentError, "if a block is passed there should be no arguments"
      end
      cond = HH::EventCondition.new &blk
      on_event(args[0], cond) {next_page}
    else
      on_event(*args) {next_page}
    end
  end

  def delete_event_connections
    @event_connections.each do |ec|
      app.delete_event_connection ec
    end
    @event_connections = []
  end

  def next_page
    @lesson_set.next_page
  end
end


# class to load and execute the level sets
class HH::LessonSet
  include HH::Observable

  attr_reader :name

  def initialize name
    @lessons = []
    @name = name
    @container = HH::LessonContainer.new self
  end

  # returns only when close gets called
  def execute_in slot
    # loads saved lesson and page, of 0, 0, by default
    # differently from what is displayed in the UI,
    # internally @lesson and @page start at 0
    @lesson = (HH::PREFS["tut_lesson_#@name"] || "0").to_i
    @page = (HH::PREFS["tut_page_#@name"] || "0").to_i
    @container.slot = slot
    slot.extend HH::Tooltip

    execute_page
    @@open_lesson = self
  end

  # finalization in case of an open lesson
  def self.close_open_lesson
    if (defined? @@open_lesson) && @@open_lesson
      @@open_lesson.save_lesson
    end
  end

  def show_menu
    name, lessons = @name, @lessons
    lesson_set = self
    @container.set_content do # NOTE: @container will instance_eval this block.
      background gray(0.1)
      stack :margin => 10, :height => -32, :scroll => true do
        title name

        lesson_i = 0
        lessons.each do |lesson_obj|
          lesson = lesson_i
          lesson_i += 1

          subtitle "#{lesson_i} #{lesson_obj.name}"#, :stroke => gray(0.9)
          page_i = 0
          lesson_obj.pages.each do |page_obj|
            page = page_i
            page_i += 1
            open_page = proc do lesson_set.instance_eval do
              @lesson, @page = lesson, page
              execute_page
            end end
            para link("#{page_obj.title}", :stroke => gray(0.9),
                                           :click => open_page),
                 :margin_left => 10
          end
        end
      end
      flow :height => 32,  :bottom => 0, :right => 0 do
        icon_button :x, :right => 10 do
          lesson_set.close_lesson
        end
      end
    end
  end

  # displays the page @page of lesson @lesson
  def execute_page
    lessons = @lessons
    lesson, page = @lesson, @page
    lesson_set = self

    @container.set_content do # NOTE: @container will instance_eval this block.
      background gray(0.1)

      lesson_object = lessons[lesson]
      page_object = lesson_object.pages[page]

      stack :margin => 10, :height => -32, :scroll => true do
        # if first page of a lesson display the lesson name
        if page == 0
          title "#{lesson+1}. #{lesson_object.name}"
        end

        # if first page of a lesson do not display page number
        page_num = page == 0 ? "" : "#{lesson+1}.#{page+1} "
        subtitle "#{page_num}#{page_object.title}"

        page_object.render_to self # Reminder: self == @container
      end

      flow :height => 32,  :bottom => 0, :right => 0 do
        icon_button :arrow_left, "Previous", :left => 10 do
          lesson_set.previous_page
        end
        icon_button :arrow_right, "Next", :left => 100 do
          lesson_set.next_page
        end
        icon_button :menu, "Index", :left => 55 do
          lesson_set.show_menu
        end
        icon_button :x, "Close", :right => 10 do
          lesson_set.close_lesson
        end
      end
    end
  end

  def next_page
    @page += 1
    lesson = @lessons[@lesson]
    if @page >= lesson.pages.size
      @page = 0
      @lesson += 1
      if @lesson >= @lessons.size
        @lesson = 0
      end
    end
    execute_page
  end

  def previous_page
    @page -= 1
    if @page < 0
      @lesson -= 1
      if @lesson < 0
        @lesson = @lessons.size-1
      end
    lesson = @lessons[@lesson]
      @page = lesson.pages.size-1
    end
    execute_page
  end

  # calls finalization
  def close_lesson
    save_lesson
    @container.delete_event_connections
    @@open_lesson = nil
    emit :close
  end

  # called on close to save the current lesson and page
  def save_lesson
    HH::PREFS["tut_lesson_#@name"] = @lesson
    HH::PREFS["tut_page_#@name"] = @page
    HH.save_prefs
  end

  def add_lesson(name)
    HH::Lesson.new(name).tap do |lesson|
      @lessons << lesson
    end
  end

  def add_page(title)
    HH::LessonPage.new(title).tap do |page|
      @lessons.last.add_page(page)
    end
  end
end

class HH::Lesson
  attr_reader :name, :pages

  def initialize(name)
    @name = name
    @pages = []
  end

  def add_page(page)
    @pages.push(page)
  end
end

class HH::LessonPage
  attr_reader :title

  def initialize(title)
    @title = title
    @actions = []
  end

  def render_to(container)
    renderer = HH::LessonPageRenderer.new(container)
    markdown = Redcarpet::Markdown.new(renderer)
    
    @actions.each do |action|
      case action
        when String
          markdown.render(action)
        when Proc
          action.call(container)
      end
    end
  end
  
  def add_action(&blk)
    @actions << blk
  end

  def add_para(markdown)
    @actions.push(markdown)
  end
end

class HH::LessonLoader
  def initialize
    @lesson_cache = {}
  end

  def load_lesson(lesson_file)
    unless @lesson_cache.has_key?(lesson_file)

      lesson_src = File.read(lesson_file)
      renderer = HH::LessonRenderer.new
      markdown = Redcarpet::Markdown.new(renderer)
      markdown.render(lesson_src)

      @lesson_cache[lesson_file] = renderer.lesson_set
    end

    @lesson_cache[lesson_file]
  end
end

class HH::LessonRenderer < Redcarpet::Render::Base
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
    @current_page.add_para(text)
    ''
  end
  
  def defer(&blk)
    @current_page.add_action(&blk)
    ''
  end
  
  def block_code(src, language)
    defer { |container| container.embed_code(src.chomp) }
  end

  def image(path, title, alt_text)

    # HH::STATIC  ->  HH::HOME + "/static"  ->  Dir.pwd + "/static"
    # This is a good example of the kind of necessary-muck I want to minimize.
    on_click = if alt_text.nil? || alt_text.empty?
                 Proc.new {}
               else
                 Proc.new { alert(alt_text) }
               end

    if path.start_with? "/icon_button/"
      path.sub! '/icon_button/', ''
      defer { |container| container.icon_button(path.to_sym, nil, &on_click) }

    else
      path = File.join(HH::HOME, path)  # TODO unless it's a URL
      defer { |container| container.image(path, {}, &on_click) }
    end
  end
end

class HH::LessonPageRenderer < Redcarpet::Render::Base
  
  def initialize(container)
    super()
    @container = container
    @args = []
  end
  
  def normal_text(text)
    text.gsub(/\n/, ' ') unless text.nil?
  end
  
  def emphasis(text)
    store @container.em(text)
  end
  
  def double_emphasis(text)
    store @container.strong(text)
  end
  
  def link(link, title, content)
    store @container.link(content, :click => link)
  end
  
  def codespan(code)
    store @container.code(code)
  end

  def store(shoes_bit)
    @args << shoes_bit
    '[-]'
  end
  
  def paragraph(text)
    #puts text
    
    #text.gsub!(/\n/, ' ')
    text = text.split('[-]')
    para_bits = text.zip(@args).flatten[0..-2]
    
    #puts "para_bits: #{para_bits.inspect}"
    @container.instance_eval { para *para_bits }
    
    @args.clear
    
    ''
  end
  
end
