source "https://rubygems.org"

gem "rails", "~> 8.1.1"
gem "pg"
gem "puma", ">= 5.0"

# Windows timezone support
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Background jobs (you need this!)
gem "solid_queue"
gem "pusher"
# Faster boot times
gem "bootsnap", require: false

# CORS - needed for frontend to call your API!
gem "rack-cors"

# Rate limiting - protect API from abuse
gem "rack-attack"

# HTTP client for calling ElevenLabs API
gem "httparty"

# AWS S3 for storing audio files (or use cloudinary gem instead)
gem "aws-sdk-s3"

# Resend for email via HTTP API (works on Railway free tier - 100 emails/day free)
gem "resend"

group :development do
  # Environment variables (only for development, not test)
  gem "dotenv-rails"
end

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # SQLite for test database (simpler than setting up separate Postgres)
  gem "sqlite3"

  # Testing
  gem "rspec-rails"        # They asked for RSpec
  gem "factory_bot_rails"  # Test data factories
  gem "webmock"            # Mock HTTP requests (for ElevenLabs API tests)

  # Code quality
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end
