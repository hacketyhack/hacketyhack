require 'thread'

class HH::LessonSet

  def initialize blk
    # use of @pages:
    # name, pages = @lessons[lesson_n]
    # title, block = pages[page_n]
    @lessons = []
    instance_eval &blk
  end

  # returns only when close gets called
  def execute_in container
    @lesson, @page = 0, 0
    @container = container
    @execution_thread = Thread.current
    Thread.new do
      begin
        execute_page
      rescue => ex
        error ex
      end
    end
    sleep # wait until the close button gets called
  end

  def execute_page
    container = @container
    execution_thread = @execution_thread
    lessons = @lessons
    lesson, page = @lesson, @page
    lesson_set = self

    container.app do
      container.clear do
      background gray(0.1)

      lesson_name, pages = lessons[lesson]
      page_title, page_block = pages[page]

      # if first page of a lesson display the lesson name
      if page == 0
        para "#{lesson+1}. #{lesson_name}",
        :stroke => white, :size => 22, :margin => 10
      end

      # if first page of a lesson don't display page number
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
