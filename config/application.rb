require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WheelerCentre
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Canberra"

    config.exceptions_app = self.routes

    # Add helpers to the load path
    config.autoload_paths << Rails.root.join("lib", "helpers")

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    Rails.application.config.assets.precompile += %w( html5shiv.js )

    # Remove below lines in Rails 5, it was temp solution in Rails 4
    config.active_record.raise_in_transactional_callbacks = true
  end
end

require "heracles-admin"
require "heracles-admin-user-auth"
require "heracles_single_site_shim"
require "helpers/redcarpet_renderers"
require Rails.root.join("app/helpers/tracking_helper")
require "section_filter"
require "assets_filter"
