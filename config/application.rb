require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RubyRailsPrac
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # The setting of time and locale
    config.time_zone = "Tokyo"
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]

    # In the case of hands-on, stop automatical generations
    config.generators do |g|
      g.assets false
      g.controller_specs false
      g.helper false
      g.skip_routes true
      g.test_framework :rspec
      g.view_specs false
    end

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end

