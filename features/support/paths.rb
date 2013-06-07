module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the home\s?page/
      '/'
    when /the blog page/
      '/blog'
    when /the questions page/
      '/questions'
    when /the lessons page/
      '/lessons'
    when /the programs page/
      '/programs'
    when /the faq page/
      '/faq'
    when /the support page/
      '/support/questions'
    when /the login page/
      '/login'
    when /the signup page/
      '/users/sign_up'
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
