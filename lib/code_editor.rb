require_relative 'editor/commands'
require_relative 'editor/undo_redo'

module HH::Editor

  class CodeEditor
    include UndoRedo

    attr_reader :script, :name, :last_saved

    def initialize script
      @script = script[:script] || ""
      @name = script[:name] || "A New Program"
      reset_undo_redo
    end

    def insert_text pos, text
      add_command InsertionCommand.new(pos, text)
      @script.insert(pos, text)
    end

    def delete_text pos, len
      text = @script[pos, len]
      return if text.empty? # happens if len == 0 or pos to big
      add_command DeletionCommand.new(pos, text)

      @script[pos, len] = "" # TODO use slice?
    end

    def save name
      @name = name
      HH.save_script(@name, @script)
      @last_saved = Time.now
    end

  end

end

