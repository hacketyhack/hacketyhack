require 'thread'

# the code in the +page+ blocks in the lessons is executed with +self+
# being a LessonContainer, methods of the main app (and thus of shoes) are
# available because missing methods get propagated there
class HH::LessonContainer
  attr_accessor :container

  def initialize lesson_set
    @lesson_set = container, lesson_set
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
    reset_connections
    @container.clear { instance_eval &blk }
  end

  def on_event *args, &blk
    conn = app.on_event(*args, &blk)
    @event_connections << conn
    conn
  end

  def next_when *args
    on_event(*args) {next_page}
  end

  def reset_connections
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
  def initialize blk
    # content of @lessons:
    # name, pages = @lessons[lesson_n]
    # title, block = pages[page_n]
    @lessons = []
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

    @execution_thread = Thread.current
    @page_thread = Thread.new { execute_page }
    sleep # wait until the close button gets called
  end

  def execute_page
    execution_thread = @execution_thread
    lessons = @lessons
    lesson, page = @lesson, @page
    lesson_set = self

    @container.set_content do
      background gray(0.1)

      lesson_name, pages = lessons[lesson]
      page_title, page_block = pages[page]

      # if first page of a lesson display the lesson name
      if page == 0
        para "#{lesson+1}. #{lesson_name}",
        :stroke => white, :size => 22, :margin => 10
      end

      # if first page of a lesson do not display page number
      page_num = page == 0 ? "" : "#{lesson+1}.#{page+1} "
      para "#{page_num}#{page_title}",
        :stroke => white, :size => 18, :margin => 10

      flow :margin => 10 do
        instance_eval &page_block
      end
      
      flow :height => 40,  :bottom => 0, :right => 0 do
        glossb "previous", :width => 100 do
          lesson_set.previous_page
        end
        glossb "next", :width => 100 do
          lesson_set.next_page
        end
        glossb "close", :width => 100, :right => 0 do
          execution_thread.wakeup
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
