# the code editor tab contents

class HH::SideTabs::Editor < HH::SideTab
  # common code between InsertionAction and DeletionAction
  # on_insert_text and on_delete_text should be called before any subclass
  # can be used
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

  module UndoRedo

    def reset_undo_redo
      @command_stack = [] # array of actions
      @stack_position = 0;
      @last_position = nil
    end

    # _act was added for consistency with redo_act
    def undo_command
      return if @stack_position == 0
      @stack_position -= 1;
      @command_stack[@stack_position].unexecute;
    end

    # _act was added because redo is a keyword
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
end # module HH::Editor

class HH::SideTabs::Editor
  include HH::Markup
  include UndoRedo

  def content
    draw_content
  end

  def load script
    if not @save_button.hidden
      # current script is unsaved
      name = @script[:name] || "An unnamed program"
      if not confirm("#{name} has not been saved, if you continue \n" +
          " all unsaved modifications will be lost")
        return false
      end
    end
    clear {draw_content script}
    true
  end

  # asks confirmation and then saves (or not if save is)
  def save_if_confirmed
    if not @save_button.hidden
      name = @script[:name] || "unnamed program"
      question = "I'm going to save modifications to \"#{name}\". Is that okay?\n" +
        "Press OK if it is, and cancel if it's not."
      if confirm(question)
        save @script[:name]
        true
      else
        false
      end
    end
  end

  def draw_content(script = {})
    @str = script[:script] || ""
    name = script[:name] || "A New Program"
    @script = script

    reset_undo_redo
    InsertionDeletionCommand.on_insert_text {|pos, str|  insert_text(pos, str)}
    InsertionDeletionCommand.on_delete_text {|pos, len|  delete_text(pos, len)}
    @editor = stack :margin_left => 10, :margin_top => 10, :width => 1.0, :height => 92 do
      @sname = subtitle name, :font => "Lacuna Regular", :size => 22,
        :margin => 0, :wrap => "trim"
      @stale = para(script[:mtime] ? "Last saved #{script[:mtime].since} ago." :
        "Not yet saved.", :margin => 0, :stroke => "#39C")
      glossb "New Program", :top => 0, :right => 0, :width => 160 do
        load({})
      end
    end
    stack :margin_left => 0, :width => 1.0, :height => -92 do
      background white(0.4), :width => 38
      @scroll =
      flow :width => 1.0, :height => 1.0, :margin => 2, :scroll => true do
        stack :width => 37, :margin_right => 6 do
          @ln = para "1", :font => "Liberation Mono", :size => 10, :stroke => "#777", :align => "right"
        end
        stack :width => -37, :margin_left => 6, :margin_bottom => 60 do
          @t = para "", :font => "Liberation Mono", :size => 10, :stroke => "#662",
            :wrap => "trim", :margin_right => 28
          @t.cursor = 0
          def @t.hit_sloppy(x, y)
            x -= 6
            c = hit(x, y)
            if c
              c + 1
            elsif x <= 48
              hit(48, y)
            end
          end
        end
        motion do |x, y|
          c = @t.hit_sloppy(x, y)
          if c
            if self.cursor == :arrow
              self.cursor = :text
            end
            if self.mouse[0] == 1 and @clicked
              if @t.marker.nil?
                @t.marker = c
              else
                @t.cursor = c
              end
            end
          elsif self.cursor == :text
            self.cursor = :arrow
          end
        end
        release do
          @clicked = false
        end
        click do |_, x, y|
          c = @t.hit_sloppy(x, y)
          if c
            @clicked = true
            @t.marker = nil
            @t.cursor = c
          end
          update_text
        end
        leave { self.cursor = :arrow }
      end
    end

    stack :height => 40, :width => 182, :bottom => -3, :right => 0 do
      
      @copy_button = 
        glossb "Copy", :width => 60, :top => 2, :left => 70 do
          save(nil)
        end
      @save_button =
        glossb "Save", :width => 60, :top => 2, :left => 70, :hidden => true do
          if save(script[:name])
            timer 0.1 do
              @save_button.hide
              @copy_button.show
              @save_to_cloud_button.show
            end
          end
        end
      @save_to_cloud_button =
        glossb "Upload", :width => 70, :top => 2, :left => 0 do
          hacker = Hacker.new :username => HH::PREFS['username'], :password => HH::PREFS['password']
          hacker.save_program_to_the_cloud(script[:name].to_slug, @str) do |response|
            if response.status == 200
              alert("Uploaded!")
            else 
              alert("There was a problem, sorry!")
            end
          end
        end
      glossb "Run", :width => 52, :top => 2, :left => 130 do
        eval(@str, HH.anonymous_binding)
      end
    end

    every 20 do
      if script[:mtime]
        @stale.text = "Last saved #{script[:mtime].since} ago."
      end
    end

    def onkey(k)
      case k when :shift_home, :shift_end, :shift_up, :shift_left, :shift_down, :shift_right
        @t.marker = @t.cursor unless @t.marker
      when :home, :end, :up, :left, :down, :right
        @t.marker = nil
      end

      case k
      when String
        if k == "\n"
          # handle indentation
          ind = indentation_size
          handle_text_insertion(k)
          handle_text_insertion(" " * ind) if ind > 0
        else
          # usual case
          handle_text_insertion(k)
        end
      when :backspace, :shift_backspace, :control_backspace
        if @t.cursor > 0 and @t.marker.nil?
          @t.marker = @t.cursor - 1 # make highlight length at least 1
        end
        sel = @t.highlight
        if sel[0] > 0 or sel[1] > 0
          handle_text_deletion(*sel)
        end
      when :delete
        sel = @t.highlight
        sel[1] = 1 if sel[1] == 0
        handle_text_deletion(*sel)
      when :tab
        handle_text_insertion("  ")
#      when :alt_q
#        @action.clear { home }
      when :control_a, :alt_a
        @t.marker = 0
        @t.cursor = @str.length
      when :control_x, :alt_x
        if @t.marker
          sel = @t.highlight
          self.clipboard = @str[*sel]
          if sel[1] == 0
            sel[1] = 1
            raise "why did this happen??"
          end
          handle_text_deletion(*sel)
        end
      when :control_c, :alt_c, :control_insertadd_characte
        if @t.marker
          self.clipboard = @str[*@t.highlight]
        end
      when :control_v, :alt_v, :shift_insert
        handle_text_insertion(self.clipboard) if self.clipboard
      when :control_z
        debug("undo!")
        undo_command
      when :control_y, :alt_Z, :shift_alt_z
        redo_command
      when :shift_home, :home
        nl = @str.rindex("\n", @t.cursor - 1) || -1
        @t.cursor = nl + 1
      when :shift_end, :end
        nl = @str.index("\n", @t.cursor) || @str.length
        @t.cursor = nl
      when :shift_up, :up
        if @t.cursor > 0
          nl = @str.rindex("\n", @t.cursor - 1)
          if nl
            horz = @t.cursor - nl
            upnl = @str.rindex("\n", nl - 1) || -1
            @t.cursor = upnl + horz
            @t.cursor = nl if @t.cursor > nl
          end
        end
      when :shift_down, :down
        nl = @str.index("\n", @t.cursor)
        if nl
          if @t.cursor > 0
            horz = @t.cursor - (@str.rindex("\n", @t.cursor - 1) || -1)
          else
            horz = 1
          end
          dnl = @str.index("\n", nl + 1) || @str.length
          @t.cursor = nl + horz
          @t.cursor = dnl if @t.cursor > dnl
        end
      when :shift_right, :right
        @t.cursor += 1 if @t.cursor < @str.length
      when :shift_left, :left
        @t.cursor -= 1 if @t.cursor > 0
      end
      if k
        text_changed
      end

      update_text
    end

    spaces = [?\t, ?\s, ?\n]

    keypress do |k|
      onkey(k)
      if @t.cursor_top < @scroll.scroll_top
        @scroll.scroll_top = @t.cursor_top
      elsif @t.cursor_top + 92 > @scroll.scroll_top + @scroll.height
        @scroll.scroll_top = (@t.cursor_top + 92) - @scroll.height
      end

    end

    # for samples do not allow to upload to cloud when just opened
    @save_to_cloud_button.hide if script[:sample]
    update_text
  end

  # saves the file, asks for a new name if a nil argument is passed
  def save name
    if name.nil?
      msg = ""
      while true
        name = ask(msg + "Give your program a name.")
        break if name.nil? or not HH.script_exists?(name)
        msg = "You already have a program named '" + name + "'.\n"
      end
    end
    if name
      @script[:name] = name
      HH.save_script(@script[:name], @str)
      @script[:mtime] = Time.now
      @sname.text = @script[:name]
      @stale.text = "Last saved #{@script[:mtime].since} ago."
      true
    else
      false
    end
  end
  
  def update_text
    @t.replace *highlight(@str, @t.cursor)
    @ln.replace [*1..(@str.count("\n")+1)].join("\n")
  end

  def text_changed
    if @save_button.hidden
      @copy_button.hide
      @save_button.show
      @save_to_cloud_button.hide
    end
  end

  # find the indentation level at the current cursor or marker
  # whatever occurs first
  # the result is the number of spaces
  def indentation_size
    # TODO marker
    pos = @str.rindex("\n", @t.cursor-1)
    return 0 if pos.nil?

    pos += 1

    ind_size = 0
    while @str[pos, 1] == ' '
      ind_size += 1
      pos += 1
    end
    ind_size
  end

  # called when the user wants to insert text
  def handle_text_insertion str
      pos, len = @t.highlight;
      handle_text_deletion(pos, len) if len > 0

      add_command InsertionCommand.new(pos, str)
      insert_text(pos, str)
  end

  # called when the user wants to delete text
  def handle_text_deletion pos, len
    str = @str[pos, len]
    return if str.empty? # happens if len == 0 or pos to big
    add_command DeletionCommand.new(pos, str)
    delete_text(pos, len)
  end

  def insert_text pos, text
    @str.insert(pos, text)
    @t.cursor = pos + text.size
    @t.cursor = :marker # XXX ???
    #update_text
  end

  def delete_text pos, len
    @str[pos, len] = "" # TODO use slice?
    @t.cursor = pos
    @t.cursor = :marker
    #update_text
  end
end
