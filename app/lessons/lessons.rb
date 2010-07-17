require 'thread'

class HH::LessonSet
  def initialize blk
    @pages = {1 => []}
    instance_eval &blk
    if @lesson_n.nil?
      @lesson_n = 1
    end
  end

  # returns only when close gets called
  def execute_in container
    @lesson = 1
    @page = 0
    @container = container
    @execution_thread = Thread.current
    Thread.new do
      begin
        execute_page
      rescue => ex
        puts ex
      end
    end
    sleep # wait until the close button gets called
  end

  def execute_page
    container = @container
    execution_thread = @execution_thread
    page_block = @pages[@lesson][@page]
    lesson, page = @lesson, @page
    lesson_set = self
    container.app do
      container.clear do
      background gray(0.1)
      para "Lesson #{lesson}, page #{page+1}", :stroke => white, :weight => "bold"
      flow :margin => 10 do
        instance_eval &page_block
      end
      glossb "close" do
        execution_thread.wakeup
      end
      glossb "next" do
        lesson_set.next_page
        lesson_set.execute_page
      end
    end
    end
  end

  def next_page
    @page += 1
    if @page >= @pages[@lesson].size
      @page = 0
      @lesson += 1
      if @lesson > @lesson_n
        @lesson = 1
      end
    end
  end

  def lesson _
    if @lesson_n.nil?
      @lesson_n = 1
    else
      @lesson_n += 1
    end
    @pages[@lesson_n] = []
  end

  def page name, &blk
    @pages[@lesson_n] << blk
  end
end
