require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)
ENV.delete("DATABASE_URL") if Rails.env.test?

module VoiceGen
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.api_only = true
  end
end
