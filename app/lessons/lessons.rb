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
    page_title, page_block = @pages[@lesson][@page]
    lesson, page = @lesson, @page
    lesson_set = self
    container.app do
      container.clear do
      background gray(0.1)
      #if page == 0
      #  para "#{lesson}.#{page+1} #{page_title}",
      #  :stroke => white, :size => 22, :margin => 10
      #end
      para "#{lesson}.#{page+1} #{page_title}",
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
    if @page >= @pages[@lesson].size
      @page = 0
      @lesson += 1
      if @lesson > @lesson_n
        @lesson = 1
      end
    end
    execute_page
  end

  def previous_page
    @page -= 1
    if @page < 0
      @lesson -= 1
      if @lesson < 1
        @lesson = @lesson_n
      end
      @page = @pages[@lesson].size-1
    end
    execute_page
  end

  def lesson _
    if @lesson_n.nil?
      @lesson_n = 1
    else
      @lesson_n += 1
    end
    @pages[@lesson_n] = []
  end

  def page title, &blk
    @pages[@lesson_n] << [title, blk]
  end
end
