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

    # thread actually executing the program
    program_thread = Thread.new do
      sleep
      timer(0.01) do
        begin
          ans = eval(code, ::TOPLEVEL_BINDING)
          say "Program terminated successfully"
          HH::APP.instance_eval {@stop_button.text = "Close"}
          HH::APP.emit :program_run, :code => code, :answer => ans
        rescue => ex
          HH::APP.emit :program_run_with_error, :code => code, :error => ex
          say ex.friendly
        end
      end
    end

    HH::APP.app do
    popup = stack :top => 0, :left => 0, :width => 1.0, :height => 1.0 do
      background black(0.8)
      # "pop up" window
      stack :top => 0.1, :left => 0.1, :width => 0.8, :height => 0.8 do
        background "#eee", :curve => 5
        @program_running = stack :margin => 10 do
          para "Running..."
        end
        @stop_button = glossb "Stop Program", :margin => 10 do
          program_thread.kill
          popup.remove
          HH::APP.emit :program_closed, :code => code
          STDOUT.delete_event_connection @stdout_connection
        end
        para "Output:", :margin_left => 20, :stroke => green
        @output = flow :margin => 10
        @stdout_connection = STDOUT.on_event :output, String do |str|
          debug "appending"
          @output.append do
            para str, :font => "Liberation Mono"
          end
        end
      end
    end
    end

    program_thread.wakeup
  end
end
