module HH::Prefs
  def loading_stack *a
    n = nil
    s = stack(*a) do
      background black(0.4), :curve => 12
      stroke white(0.6)
      fill white(0.6)
      para "\nLoading.\n\n", :align => "center", :size => 17,
        :font => "Lacuna Regular", :stroke => white
      o1 = oval -400, 0, 16
      o2 = oval -400, 0, 16
      n = animate do |i|
        v1 = Math.sin(i * 0.2) * 5
        v2 = Math.cos(i * 0.2) * 5
        o1.move(((s.width - 50) * 0.5) + v1, 85 + v2)
        o2.move(((s.width - 50) * 0.5) - v1, 85 - v2)
      end
    end
    s.instance_variable_set("@n", n)
    def s.replace &blk
      @n.stop; @n = nil
      clear &blk
    end
    s
  end

  def clover_whoosh
    # background white(0.0)..white(0.7), :height => 253, :top => 71, :width => -57, :angle => 90
    # background white(0.0)..white(0.7), :height => 158, :top => 118, :width => -57, :angle => 90
    background "#efefa0"
    background "#efefa0".."#c1d5c0", :height => 150, :bottom => 150
    # image "#{HH::STATIC}/splash-hand.png", :right => -40, :top => 70
  end

  def send_message
    clover_whoosh
    stack :margin => [50, 20, 0, 20], :width => 1.0, :height => 1.0 do
      para(link("Your Messages", :font => "Lacuna Regular", :size => 10,
        :stroke => black) { @action.clear { prefs } }, :margin => 0)
      subtitle "Send a Message", :font => "Lacuna Regular", :margin => 0, :size => 17,
        :stroke => "#377"

      @error_pane = stack :margin_top => 20, :hidden => true

      stack :margin => 20, :width => 400 do
        para "To whom?", :size => 10, :margin => 2, :stroke => "#352"
        @user = edit_line :width => 1.0

        para "A title", :size => 10, :margin => 2, :stroke => "#352"
        @subj = edit_line :width => 1.0

        para "Your message", :size => 10, :margin => 2, :stroke => "#352"
        @msgt = edit_box :width => 1.0

        para "Attach a program?", :size => 10, :margin => 2, :stroke => "#352"
        @attach = list_box :items => ['- None -'] + HH.scripts.map { |s| s[:name] }.sort

        button "Send", :margin_top => 10 do
          @error_pane.clear
          code = @msgt.text.strip
          if @attach.text and @attach.text != "- None -"
            code += "\n\n--- #{@attach.text}.rb\n"
            code += HH.get_script(@attach.text)[:script]
          end
          HH.user.put_in_outbox(:who => @user.text, :subject => @subj.text,
                                :content => code) do |msg|
            case msg when Hash
              @action.clear { prefs }
            else
              @error_pane.append do
                para strong("Oops!", :stroke => "#C30"), " Message did not send."
                msg.each do |err|
                  para " - #{err}", :size => 10
                end
              end.show
            end
          end
        end
      end
    end
  end

  def open_message msg
    clover_whoosh
    stack :margin => [50, 20, 0, 20], :width => 1.0, :height => 1.0 do
      para(link("Your Messages", :font => "Lacuna Regular", :size => 10,
        :stroke => black) { @action.clear { prefs } }, :margin => 0)
      subtitle msg['subject'], :font => "Lacuna Regular", :margin => 0, :size => 17,
        :stroke => "#377"
      para "from #{msg['from']}", :stroke => "#777", :size => 9,
        :font => "Lacuna Regular", :margin => 0, :margin_bottom => 10
      stack :margin_right => 10 do
        background white(0.96)
        @content = loading_stack :margin => 10
        HH.user.get_from_inbox(msg) do |msg|
          @content.replace do
            msg['content'].split(/\n{2,}/).each do |line|
              para line.strip
            end
            if msg['script_name']
              stack :margin_left => 8, :margin => 4 do
                britelink "icon-file.png", msg['script_name'] do
                  load_editor :script => msg['script_code'], :name => msg['script_name']
                end
                para "#{msg['script_code'].length} bytes", :stroke => "#777", :size => 9,
                  :font => "Lacuna Regular", :margin => 0, :margin_left => 18
              end
            end
          end
        end
      end
    end
  end

  def prefs(page = 0)
    if @notice
      @notice.hide
      @mailcheck.start
    end
    user = HH::PREFS['username']
    clover_whoosh
    stack :margin => [50, 20, 0, 20], :width => 1.0, :height => 1.0 do
      subtitle "Your Messages", :font => "Lacuna Regular", :margin => 0, :size => 22,
        :stroke => "#377"
      if user
        para "Hello, #{user}! ",
          link("Click here") { @prefpane.toggle },
          " to alter your settings.", :size => 10
      else
        para "Let's set up Hackety Hack to use on the Internet okay? ",
          "Be sure you have an account from ",
          link("hacketyhack.net", :click => "http://hacketyhack.net"), "."
      end

      @prefpane =
      stack :hidden => !user.blank? do
        stack :margin => 20, :width => 400 do
          para "Your username", :size => 10, :margin => 2, :stroke => "#352"
          @user = edit_line user, :width => 1.0

          para "Your password", :size => 10, :margin => 2, :stroke => "#352"
          @pass = edit_line HH::PREFS['password'], :width => 1.0, :secret => true

          button "Save", :margin_top => 10 do
            HH::PREFS['username'] = @user.text
            HH::PREFS['password'] = @pass.text
            HH.save_prefs
            @action.clear { prefs }
          end
        end
      end

      if user
        @mailtable = loading_stack :margin => 20, :margin_top => 0
        start = page * 5
        HH.user.get_inbox do |box|
          @mailtable.replace do
            box[page * 5, 5].each do |msg|
              icon = msg['read'] ? "tab-email.png" : "icon-email.png"
              stack :margin_left => 8, :margin_top => 4 do
                britelink icon, msg['subject'], msg['at'], "#C66" do
                  @action.clear { open_message msg }
                end
                para "from #{msg['from']}", :stroke => "#777", :size => 9,
                  :font => "Lacuna Regular", :margin => 0, :margin_left => 18
              end
            end
            if box.length > 5
              stack :top => 0, :right => 10 do
                nex = box.length > start + 5
                if start > 0
                  glossb "<<", :top => 0, :right => 10 + (nex ? 100 : 0), :width => 50, :color => "yellow" do
                    @action.clear { prefs(page - 1) }
                  end
                end
                if nex
                  glossb "Next 5 >>", :top => 0, :right => 10, :width => 100, :color => "yellow" do
                    @action.clear { prefs(page + 1) }
                  end
                end
              end
            end
          end
        end
        para(link("Send a message.", :size => 11) { @action.clear { send_message } })
      end
    end
  end
end
