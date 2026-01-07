ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup"
require "bootsnap/setup"

ENV.delete("DATABASE_URL") if ENV["RAILS_ENV"] == "test"
