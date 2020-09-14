# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load

module Hackershare
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.active_storage.service = :local
    config.active_storage.service_urls_expire_in = 99.years
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.active_record.schema_format = :sql

    config.active_storage.content_types_to_serve_as_binary -= ["image/svg+xml"]
    config.i18n.available_locales = %i[en cn]
    config.i18n.default_locale = :en
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
    end
  end
end
