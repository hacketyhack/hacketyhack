require 'thread'

class HH::LessonSet
  # returns only when close gets called
  def execute_in container
    original_thread = Thread.current
    Thread.new do 
    container.app do
    container.clear do
      background gray(0.1)
      para "lesson n. 1", :stroke => white
      button "close" do
        original_thread.wakeup
      end
    end 
    end
    end
    sleep
  end
  def on_close &blk
    @on_close << blk
  end
end
