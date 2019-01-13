require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'enju_event'

module Dummy
  class Application < Rails::Application
<<<<<<< HEAD
=======
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

>>>>>>> febdc8c... update CI config
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.fallbacks = true
  end
end
