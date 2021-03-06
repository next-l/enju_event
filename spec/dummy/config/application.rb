require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "enju_event"
require "enju_leaf"
require "resque/server"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

