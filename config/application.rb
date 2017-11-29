require_relative 'boot'

# require 'rails/all'
require 'rails'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CqrsExploration
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.autoload_paths << Rails.root.join('lib')
    config.load_defaults 5.1
    config.action_controller.permit_all_parameters = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
