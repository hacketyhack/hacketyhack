#TODO: If I get this far, check whether it works with green shoes
#TODO: Really figure out hit_sloppy

# the code editor tab contents
# the logic behind it is handled in the CodeEditor class
# this /should/ be pure presentation
class HH::SideTabs::Editor < HH::SideTab
  include HH::Markup

  UNNAMED_PROGRAM = "An unnamed program"

  def content
    draw_content
  end

  def load script
    unless saved?
      name = @code_editor.name || UNNAMED_PROGRAM
      unless confirm("#{name} has not been saved, if you continue\n" +
          " all unsaved modifications will be lost")
        return false
      end
    end
    clear {draw_content script}
    true
  end

  def saved?
    @save_button.hidden
  end

  def empty? string
    string.nil? or string.empty?
  end

  def choose_program_name
    msg = ""
    name = ""
    while empty?(name) or HH.script_exists?(name)
      name = ask(msg + "Give your program a name.")
      msg = "Come on give your program a name :-)\n" if empty?(name)
      msg = "You already have a program named '" + name + "'.\n" if HH.script_exists?(name)
    end
    name
  end

  def save_program name
    @sname.text = name
    @code_editor.save name
    @stale.text = "Last saved #{@code_editor.last_saved.since} ago."
  end

  # saves the file, asks for a new name if a nil argument is passed
  def save name
    name = choose_program_name unless name

    if name
      save_program name
      true
    else
      false
    end
  end

  # asks confirmation and then saves (or not if cancel is pressed)
  def save_if_confirmed
    unless saved?
      name = @code_editor.name || UNNAMED_PROGRAM
      question = "I'm going to save modifications to \"#{name}\". Is that okay?\n" +
        "Press OK if it is, and cancel if it's not."
      if confirm(question)
        save name
        true
      else
        false
      end
    end
  end

  def setup_editor(script)
    @code_editor = HH::Editor::CodeEditor.new(script)

    # TODO: is there a way to work around this?
    HH::Editor::InsertionDeletionCommand.on_insert_text {|pos, str|  insert_text(pos, str)}
    HH::Editor::InsertionDeletionCommand.on_delete_text {|pos, len|  delete_text(pos, len)}
  end

  def top_bar
    stack :margin_left => 10, :margin_top => 10, :width => 1.0, :height => 92 do
      progam_name = @code_editor.name || UNNAMED_PROGRAM
      @sname = subtitle progam_name, :font => "Lacuna Regular", :size => 22,
        :margin => 0, :wrap => "trim"
      @stale = para(@code_editor.last_saved ? "Last saved #{@code_editor.last_saved.since} ago." :
        "Not yet saved.", :margin => 0, :stroke => "#39C")
      glossb "New Program", :top => 0, :right => 0, :width => 160 do
        load({})
      end
    end
  end

  def define_hit_sloppy
    # some kind of cursor movement
    def @code_para.hit_sloppy(x, y)
      x -= 6
      c = hit(x, y)
      if c
        c + 1
      elsif x <= 48
        hit(48, y)
      end
    end
  end

  def line_numbering
    stack :width => 37, :margin_right => 6 do
      @line_numbers = para "1", :font => "Liberation Mono", :size => 10,
                                :stroke => "#777", :align => "right"
    end
  end

  def editor_text
    stack :width => -37, :margin_left => 6, :margin_bottom => 60 do
      @code_para = para "", :font => "Liberation Mono", :size => 10,
                            :stroke => "#662", :wrap => "trim",
                            :margin_right => 28
      @code_para.cursor = 0
    end

    define_hit_sloppy
  end

  # TODO long if jungle - but how to make it short/work around it
  def mouse_motion
    motion do |x, y|
      c = @code_para.hit_sloppy(x, y)
      if c
        if self.cursor == :arrow
          self.cursor = :text
        end
        if self.mouse[0] == 1 and @clicked
          if @code_para.marker.nil?
            @code_para.marker = c
          else
            @code_para.cursor = c
          end
        end
      elsif self.cursor == :text
        self.cursor = :arrow
      end
    end
  end

  def mouse_release
    release do
      @clicked = false
    end
  end

  def mouse_click
    click do |_, x, y|
      c = @code_para.hit_sloppy(x, y)
      if c
        @clicked = true
        @code_para.marker = nil
        @code_para.cursor = c
      end
      update_text
    end
  end

  def mouse_leave
    leave { self.cursor = :arrow }
  end

  def mouse_actions
    mouse_motion
    mouse_release
    mouse_click
    mouse_leave
  end

  def main_editor_window
    stack :margin_left => 0, :width => 1.0, :height => -92 do
      background white(0.4), :width => 38

      @scroll =
      flow :width => 1.0, :height => 1.0, :margin => 2, :scroll => true do
        line_numbering
        editor_text
        mouse_actions
      end
    end
  end

  def copy_button
    @copy_button = glossb "Copy", :width => 60, :top => 2, :left => 70 do
      save(nil)
    end
  end

  def save_button
    @save_button =
    glossb "Save", :width => 60, :top => 2, :left => 70, :hidden => true do
      if save(@code_editor.name)
        timer 0.1 do
          @save_button.hide
          @copy_button.show
          @upload_button.show
        end
      end
    end
  end

  def upload_program
    hacker = Hacker.new :username => HH::PREFS['username'], :password => HH::PREFS['password']
    hacker.save_program_to_the_cloud(@code_editor.name, @code_editor.script) do |response|
      if response.code == "200" || response.code == "302"
        alert("Uploaded!")
      else
        alert("There was a problem, sorry!")
      end
    end
  end

  def upload_button
    @upload_button =
    glossb "Upload", :width => 70, :top => 2, :left => 0 do
      if HH::PREFS['username']
        upload_program
      else
        alert("To upload, first connect your account on hackety-hack.com by \
        clicking Preferences near the bottom left of the window.")
      end
    end
  end

  def run_button
    glossb "Run", :width => 52, :top => 2, :left => 130 do
      @code_editor.run
    end
  end

  def bottom_menu
    stack :height => 40, :width => 182, :bottom => -3, :right => 0 do
      copy_button
      save_button
      upload_button
      run_button
    end
  end

  def update_time
    every 20 do
      @stale.text = "Last saved #{@code_editor.last_saved.since} ago." if @code_editor.last_saved
    end
  end

  # do this somewhere else?
  def hide_upload_for_samples(script)
    @upload_button.hide if script[:sample]
  end

  def draw_content(script = {})
    setup_editor(script)
    top_bar
    main_editor_window
    bottom_menu
    update_time
    on_keypress
    hide_upload_for_samples(script)
    update_text
  end

  def update_text
    @code_para.replace *highlight(@code_editor.script, @code_para.cursor)
    @line_numbers.replace [*1..(@code_editor.script.count("\n")+1)].join("\n")
  end

  def text_changed
    if saved?
      @copy_button.hide
      @save_button.show
      @upload_button.hide
    end
  end

  # TODO: handle/inserts are awkward but somehow necessary for undo/redo to
  # work, better figure out another way however

  # called when the user wants to insert text
  def handle_text_insertion text
      pos, len = @code_para.highlight
      handle_text_deletion(pos, len) if len > 0

      @code_editor.handle_text_insertion pos, text
      insert_text pos, text
  end

  # called when the user wants to delete text
  def handle_text_deletion pos, len
    @code_editor.handle_text_deletion pos, len
    delete_text pos, len
  end

  def insert_text pos, text
    @code_editor.insert_text pos, text
    @code_para.cursor = pos + text.size
    @code_para.cursor = :marker # XXX ???
  end

  def delete_text pos, len
    @code_editor.delete_text pos, len
    @code_para.cursor = pos
    @code_para.cursor = :marker
  end

  # find the indentation level at the current cursor or marker
  # whatever occurs first
  # the result is the number of spaces
  def indentation_size
    # TODO marker
    pos = @code_editor.script.rindex("\n", @code_para.cursor-1)
    return 0 if pos.nil?

    pos += 1
    ind_size = 0
    while @code_editor.script[pos, 1] == ' '
      ind_size += 1
      pos += 1
    end
    ind_size
  end

  def on_keypress
    keypress do |k|
      onkey(k)
      if @code_para.cursor_top < @scroll.scroll_top
        @scroll.scroll_top = @code_para.cursor_top
      elsif @code_para.cursor_top + 92 > @scroll.scroll_top + @scroll.height
        @scroll.scroll_top = (@code_para.cursor_top + 92) - @scroll.height
      end
    end
  end

  # TODO this delegates to @code_editor
  #      wouldn't it probably be better for the editor to have his own case? hm
  def onkey(key)
    case key
    when :shift_home, :shift_end, :shift_up, :shift_left, :shift_down, :shift_right
      @code_para.marker = @code_para.cursor unless @code_para.marker
    when :home, :end, :up, :left, :down, :right
      @code_para.marker = nil
    end

    # keypress wilderness
    case key
    when String
      if key == "\n"
        # handle indentation
        ind = indentation_size
        handle_text_insertion(key)
        handle_text_insertion(" " * ind) if ind > 0
      else
        # usual case
        handle_text_insertion(key)
      end
    when :backspace, :shift_backspace, :control_backspace
      if @code_para.cursor > 0 and @code_para.marker.nil?
        @code_para.marker = @code_para.cursor - 1 # make highlight length at least 1
      end
      sel = @code_para.highlight
      if sel[0] > 0 or sel[1] > 0
        handle_text_deletion(*sel)
      end
    when :delete
      sel = @code_para.highlight
      sel[1] = 1 if sel[1] == 0
      handle_text_deletion(*sel)
    when :tab
      handle_text_insertion("  ")
#      when :alt_q
#        @action.clear { home }
    when :control_a, :alt_a
      @code_para.marker = 0
      @code_para.cursor = @code_editor.script.length
    when :control_x, :alt_x
      if @code_para.marker
        sel = @code_para.highlight
        self.clipboard = @code_editor.script[*sel]
        if sel[1] == 0
          sel[1] = 1
          raise "why did this happen??"
        end
        handle_text_deletion(*sel)
      end
    when :control_c, :alt_c, :control_insertadd_characte
      if @code_para.marker
        self.clipboard = @code_editor.script[*@code_para.highlight]
      end
    when :control_v, :alt_v, :shift_insert
      handle_text_insertion(self.clipboard) if self.clipboard
    when :control_z
      @code_editor.undo_command
    when :control_y, :alt_Z, :shift_alt_z
      @code_editor.redo_command
    when :shift_home, :home
      nl = @code_editor.script.rindex("\n", @code_para.cursor - 1) || -1
      @code_para.cursor = nl + 1
    when :shift_end, :end
      nl = @code_editor.script.index("\n", @code_para.cursor) || @code_editor.script.length
      @code_para.cursor = nl
    when :shift_up, :up
      if @code_para.cursor > 0
        nl = @code_editor.script.rindex("\n", @code_para.cursor - 1)
        if nl
          horz = @code_para.cursor - nl
          upnl = @code_editor.script.rindex("\n", nl - 1) || -1
          @code_para.cursor = upnl + horz
          @code_para.cursor = nl if @code_para.cursor > nl
        end
      end
    when :shift_down, :down
      nl = @code_editor.script.index("\n", @code_para.cursor)
      if nl
        if @code_para.cursor > 0
          horz = @code_para.cursor - (@code_editor.script.rindex("\n", @code_para.cursor - 1) || -1)
        else
          horz = 1
        end
        dnl = @code_editor.script.index("\n", nl + 1) || @code_editor.script.length
        @code_para.cursor = nl + horz
        @code_para.cursor = dnl if @code_para.cursor > dnl
      end
    when :shift_right, :right
      @code_para.cursor += 1 if @code_para.cursor < @code_editor.script.length
    when :shift_left, :left
      @code_para.cursor -= 1 if @code_para.cursor > 0
    end

    if key
      text_changed
    end
    update_text
  end

end

