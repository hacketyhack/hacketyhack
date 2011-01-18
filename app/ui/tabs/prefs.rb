# the messages tab content

class HH::SideTabs::Prefs < HH::SideTab
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
    background "#efefa0"
    background "#efefa0".."#c1d5c0", :height => 150, :bottom => 150
  end

  def content
    user = HH::PREFS['username']
    stack :margin => [10, 20, 0, 20], :width => 1.0, :height => 1.0 do
      subtitle "Your Preferences", :font => "Lacuna Regular", :margin => 0, :size => 22,
        :stroke => "#377"
      if user
        para "Hello, #{user}! ",
      else
        @question_stack = stack do
          para "You can connect with your account on ", 
               link("hackety-hack.com", :click => "http://hackety-hack.com"),
               " to do all kinds of fun stuff. Do you have one?"
          button "Yes" do
            @question_stack.toggle
            @prefpane.toggle
          end
          
          button "No" do
            @question_stack.toggle
            @signup_stack.toggle
          end
        end
      end

      @prefpane = stack :margin => 20, :width => 400 do
        para "Website credentials", :size => :large
        para "Your username", :size => 10, :margin => 2, :stroke => "#352"
        @user = edit_line user, :width => 1.0

        para "Your password", :size => 10, :margin => 2, :stroke => "#352"
        @pass = edit_line HH::PREFS['password'], :width => 1.0, :secret => true

        button "Save", :margin_top => 10 do
          hacker = Hacker.new :username => @user.text, :password => @pass.text 
          hacker.auth_check do |response|
            if response.status == 200
              HH::PREFS['username'] = @user.text
              HH::PREFS['password'] = @pass.text
              HH.save_prefs

              alert("Saved, thanks!")
            else
              alert("Sorry, I couldn't authenticate you. Did you sign up for an account at http://hackety-hack.com/ ? Please double check what you've typed.")
            end
          end
        end
      end
      @prefpane.toggle

      @signup_stack = stack do
        para "Website Account Signup", :size => :large
        para "Let's get you set up with one! All fields are required."
        para "Username:", :size => 10, :margin => 2, :stroke => "#352"
        @user = edit_line "", :width => 1.0

        para "Email:", :size => 10, :margin => 2, :stroke => "#352"
        @email = edit_line "", :width => 1.0

        para "Password", :size => 10, :margin => 2, :stroke => "#352"
        @pass = edit_line "", :width => 1.0, :secret => true

        button "Sign up", :margin_top => 10 do
          hacker = Hacker.new :username => @user.text, :email => @email.text, :password => @pass.text
          hacker.sign_up! do |response|
            if response.status == 200
              alert("Great! We've got you signed up.")
              HH::PREFS['username'] = @user.text
              HH::PREFS['password'] = @pass.text
              HH::PREFS['email'] = @email.text
              HH.save_prefs
              @signup_stack.toggle
              @prefpane.toggle
            else
              alert("Uhhh... there was a problem. I couldn't sign you up. Make sure nobody has your username!")
            end
          end
        end

      end
      @signup_stack.toggle

    end
  end
end
