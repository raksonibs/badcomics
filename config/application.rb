require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

<<<<<<< HEAD
module Whattodo
  class Application < Rails::Application
    I18n.config.enforce_available_locales = true
=======
module Badcomics
  class Application < Rails::Application
    I18n.config.enforce_available_locales = true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
>>>>>>> 6721de769c2e5cfebde11d8b6c385461dda1287d

    config.generators do |g|
        g.test_framework :rspec, :fixture => false
        g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

    config.time_zone
    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.helper = false
    config.generators.specs = false

<<<<<<< HEAD
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.watchable_dirs['lib'] = [:rb]
=======
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.assets.paths << Rails.root.join('app','assets','fonts')
>>>>>>> 6721de769c2e5cfebde11d8b6c385461dda1287d
  end
end
