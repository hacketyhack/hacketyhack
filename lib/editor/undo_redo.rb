module HH::Editor

  module UndoRedo

    def reset_undo_redo
      @command_stack = [] # array of actions
      @stack_position = 0;
      @last_position = nil
    end

    def undo_command
      return if @stack_position == 0
      @stack_position -= 1;
      @command_stack[@stack_position].unexecute;
    end

    def redo_command
      return if @stack_position == @command_stack.size
      @command_stack[@stack_position].execute
      @stack_position += 1;
    end

    def add_command cmd
      # all redos get removed
      @command_stack[@stack_position..-1] = nil
      last = @command_stack.last
      if last.nil? or not last.merge_with(cmd)
        # create new command
        @command_stack[@stack_position] = cmd
        @stack_position += 1
      end
    end

  end

end

