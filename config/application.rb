require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AshitaRailsLesson
  class Application < Rails::Application
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
    config.generators.template_engine = :slim
    config.generators do |g|
      g.test_framework :rspec,
      view_specs: false, helper_specs: false, routing_specs: false
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
