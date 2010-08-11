# code used to run a program from the editor
#
# a message is shown displaying "Running...", and is replaced with the say
# method
#
# if an error occurs it will be displayed, but only if it happens at the top
# level: exceptions in a Shoes app or thread will just be shown in the Shoes
# console

module HH::ProgramRunner
  def run_program code
    popup = nil
    # thread actually executing the program
    program_thread = Thread.new do timer(0.01) do #Thread.new do
      begin
        ans = eval(code, ::TOPLEVEL_BINDING)
        popup.remove
        HH::APP.emit :program_run, :code => code, :answer => ans
      rescue => ex
        HH::APP.emit :program_run_with_error, :code => code, :error => ex
        say ex.friendly
      end
    end end #end

    HH::APP.app do
    popup = stack :top => 0, :left => 0, :width => 1.0, :height => 1.0 do
      background black(0.8)
      # "pop up" window
      stack :top => 100, :left => 0.3, :width => 0.4, :align => "center" do
        background "#eee", :curve => 5
        @program_running = stack :margin => 10 do
          para "Running..."
        end
        glossb "Stop Program", :margin => 10 do
          program_thread.kill
          popup.remove
          HH::APP.emit :program_killed, :code => code
        end
      end
    end
    end
  end
end
