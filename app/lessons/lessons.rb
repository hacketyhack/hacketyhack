require 'thread'

module HH::LessonContainerText
  TITLES = {:font => "Lacuna Regular", :stroke => "#e06", :margin => 4}
  PARAS = {:stroke => "#eec", :size => 11, :margin_bottom => 6}
  LIST = {:margin_left => 20, :margin => 4, :size => 10}

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
  def link *a; app.link *a end
  def code *args
    super *merge_opts( args, {:stroke => "#000", :fill => "#FF6"} )
  end
  def prompt *args
    code *merge_opts( args, {:stroke => "#EEE", :fill => "#703"} )
  end
end



# the code in the +page+ blocks in the lessons is executed with +self+
# being a LessonContainer, methods of the main app (and thus of shoes) are
# available because missing methods get propagated there
class HH::LessonContainer
  include HH::LessonContainerText

  attr_accessor :container

  def initialize lesson_set
    @lesson_set = lesson_set
    @event_connections = []
  end

  # convenience method the access the main shoes application
  def app
    @container.app
  end

  def method_missing(symbol, *args, &blk)
    app.send symbol, *args, &blk
  end

  def set_content &blk
    delete_event_connections
    @container.clear { instance_eval &blk }
  end

  def on_event *args, &blk
    conn = app.on_event(*args, &blk)
    @event_connections << conn
    conn
  end

  # on the event specified in +args+ goes to the next page
  # if a block is specified it is used as additional condition
  # the event arguments are passed to the block
  def next_when *args, &blk
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
  def initialize name, blk
    # content of @lessons:
    # name, pages = @lessons[lesson_n]
    # title, block = pages[page_n]
    @lessons = []
    @name = name
    @container = HH::LessonContainer.new self
    instance_eval &blk
  end

  def init &blk
    @container.instance_eval &blk
  end

  # returns only when close gets called
  def execute_in container    
    @lesson, @page = 0, 0
    @container.container = container
    container.extend HH::Tooltip

    @execution_thread = Thread.current
    @page_thread = Thread.new { execute_page }
    sleep # wait until the close button gets called
  end

  def show_menu
    name, lessons = @name, @lessons
    lesson_set = self
    @container.set_content do
      background gray(0.1)
      stack :margin => 10 do
        title name

        lesson_i = 0
        lessons.each do |name, pages|
          lesson = lesson_i
          lesson_i += 1
          open_lesson = proc do lesson_set.instance_eval do
            @lesson, @page = lesson, 0
            execute_page
          end end

          subtitle link("#{lesson_i} #{name}", :click => open_lesson,
                                    :underline => "none", :stroke => gray(0.9))
        end
      end
      flow :height => 40,  :bottom => 0, :right => 0 do
        puts "TODO: add"
#        icon_button :x, :right => 10 do
#          lesson_set.close_lesson
#        end
      end
    end
  end

  def execute_page
    lessons = @lessons
    lesson, page = @lesson, @page
    lesson_set = self

    @container.set_content do
      background gray(0.1)

      lesson_name, pages = lessons[lesson]
      page_title, page_block = pages[page]

      stack :margin => 10 do
        # if first page of a lesson display the lesson name
        if page == 0
          title "#{lesson+1}. #{lesson_name}"
        end

        # if first page of a lesson do not display page number
        page_num = page == 0 ? "" : "#{lesson+1}.#{page+1} "
        subtitle "#{page_num}#{page_title}"

        instance_eval &page_block
      end
      
      flow :height => 32,  :bottom => 0, :right => 0 do
        icon_button :arrow_left, "Next", :left => 10 do
          lesson_set.previous_page
        end
        icon_button :arrow_right, "Previous", :left => 100 do
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
    _name, pages = @lessons[@lesson]
    if @page >= pages.size
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
    _name, pages = @lessons[@lesson]
      @page = pages.size-1
    end
    execute_page
  end

  def close_lesson
    @container.delete_event_connections
    @execution_thread.wakeup
  end

  def lesson name
    @lessons << [name, []]
  end

  def page title, &blk
    if @lessons.empty?
      lesson << "Lesson"
    end
    _name, pages = @lessons.last
    pages << [title, blk]
  end
end
