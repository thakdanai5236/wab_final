require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FinalWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Avoid reloading or eager-loading unnecessary lib directories
    config.autoload_lib(ignore: %w[assets tasks])

    # Disable CSS and JS compression to make debugging assets easier
    config.assets.css_compressor = nil
    config.assets.js_compressor = nil

    # Add custom paths for eager loading or autoloading if needed
    # config.eager_load_paths << Rails.root.join("extras")

    # Set the default time zone if needed
    # config.time_zone = "Central Time (US & Canada)"
  end
end
