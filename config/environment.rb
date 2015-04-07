# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
<<<<<<< HEAD
Whattodo::Application.initialize!

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.configure do |config|
  config.run_server = true
  config.current_driver = :webkit
  config.app_host = 'http://nowtoronto.com/search/event/all'
  config.automatic_reload = false
end

=======
Rails.application.initialize!
>>>>>>> 6721de769c2e5cfebde11d8b6c385461dda1287d
