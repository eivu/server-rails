require_relative 'boot'

require 'rails/all'
require 'action_cable/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Eivu
  class Application < Rails::Application
    #autoload everything in the app folder
    config.autoload_paths += %W(#{config.root}/app/**)
    config.autoload_paths << Rails.root.join('lib')

    config.to_prepare do
      Devise::SessionsController.skip_before_action :authenticate_user!
    end

    # ActiveJob configuration
    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec
    end

    # fixing cors issue
    config.middleware.insert_before 0, Rack::Cors do
      allow do
         origins '*'
         resource '*', :headers => :any, :methods => [:get, :post, :options]
       end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
