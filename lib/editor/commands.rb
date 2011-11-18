# the different commands insertion/deletion

module HH::Editor
  # common code between InsertionAction and DeletionAction
  # on_insert_text and on_delete_text should be called before any subclass
  # can be used
  # TODO: weirdly generic... couldn't it do that itself?
  class InsertionDeletionCommand

    def self.on_insert_text &block
      @@insert_text = block
    end

    def self.on_delete_text &block
      @@delete_text = block
    end

    # action to insert/delete str to text at position pos
    def initialize pos, str
      @position, @string = pos, str
    end

    def insert
      @@insert_text.call(@position, @string)
    end

    def delete
      @@delete_text.call(@position, @string.size)
    end

    protected
    attr_accessor  :position, :string
  end

  class InsertionCommand < InsertionDeletionCommand
    alias execute insert
    alias unexecute delete

    # returns nil if not mergeble
    def merge_with second
      if second.class != self.class
        nil
      elsif second.position != self.position + self.string.size
        nil
      elsif second.string == "\n"
        nil # newlines always start a new command
      else
        self.string += second.string
        self
      end
    end
  end

  class DeletionCommand < InsertionDeletionCommand
    alias execute delete
    alias unexecute insert

    def merge_with second
      if second.class != self.class
        nil
      elsif second.string == "\n"
        nil
      elsif second.position == self.position
        # probably the delete key
        self.string += second.string
        self
      elsif self.position == second.position + second.string.size
        # probably the backspace key
        self.position = second.position
        self.string = second.string + self.string
        self
      else
        nil
      end
    end

  end

end

