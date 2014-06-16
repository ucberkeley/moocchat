# Load the rails application
require File.expand_path('../application', __FILE__)
require 'capybara/rails' 

# Initialize the rails application
Moocchat::Application.initialize!

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
