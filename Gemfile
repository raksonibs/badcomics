source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

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

# Asset Handling
gem 'bourbon' # Should replace w/ autoprefixer: https://github.com/ai/autoprefixer-rails
gem 'sass-rails', '~> 4.0.2'
gem 'uglifier', '>= 1.3.0'

gem 'font-awesome-rails'
gem 'jquery-rails'

gem 'headless'

# Forms
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

gem 'rack'

gem 'therubyracer',  platforms: :ruby

group :production do
  gem 'rails_12factor'

  # App Monitoring
  gem 'newrelic_rpm'

  # Server
  gem 'unicorn'
  # gem 'hooves', require: "hooves/default"
end