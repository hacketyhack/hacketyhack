# Based on: http://blogs.kent.ac.uk/webdev/2012/08/02/using-capybara-webkit-with-cucumber-without-rails-or-rack

begin
  require 'rspec/expectations'
  rescue LoadError
  require 'spec/expectations'
end

require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara-webkit'

Capybara.default_driver = :webkit

Capybara.run_server = true
Capybara.app_host = "http://hackety.com"
