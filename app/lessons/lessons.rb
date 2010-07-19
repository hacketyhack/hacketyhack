require 'thread'

module HH::LessonContainerText
  TITLES = {:font => "Lacuna Regular", :stroke => "#e06", :margin => 4}
  PARAS = {:stroke => "#eec", :size => 11, :margin_bottom => 6}
  LIST = {:margin_left => 20, :margin => 4, :size => 10}

  def title txt
    style = TITLES.clone
    style[:size] = 22
    super txt, style
  end
  def subtitle txt
    style = TITLES.clone
    style[:size] = 14
    super txt, style
  end
  def item *txt
    txt << LIST
    para *txt
  end
  def para *txt
    txt << PARAS
    super *txt
  end
  #def link *a; @lesson.link *a end
  #def em txt; @lesson.em txt end
  #def strong txt; @lesson.strong txt end
  def code *txt
    txt << {:stroke => "#000", :fill => "#FF6"}
    super *txt
  end
  def prompt txt
    code txt, :stroke => "#EEE", :fill => "#703"
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

  def next_when *args
    on_event(*args) {next_page}
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
      
      flow :height => 40,  :bottom => 0, :right => 0 do
        glossb "previous", :width => 100 do
          lesson_set.previous_page
        end
        glossb "next", :width => 100 do
          lesson_set.next_page
        end
        glossb "close", :width => 100, :right => 0 do
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
