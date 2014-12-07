source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'
gem 'roo'

gem 'pg'

gem 'capybara'
gem 'selenium-webdriver'
gem 'mechanize'
gem 'capybara-webkit'

gem 'capistrano', '~> 3.1.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'

gem 'omniauth'
gem "omniauth-facebook"

# Forms

gem "fql"
gem 'kaminari'
gem 'figaro'
gem "rspec-rails"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem "geocoder"
gem 'pry'

gem 'whenever', :require => false

group :development do
  gem "better_errors"
end

gem "nokogiri"

gem 'sidekiq'

gem 'therubyracer',  platforms: :ruby

group :production do
  gem 'rails_12factor'

  # App Monitoring
  gem 'newrelic_rpm'

  # Server
  gem 'unicorn'
  gem 'hooves', require: "hooves/default"
end