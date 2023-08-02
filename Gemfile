source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.6"

gem "rails", "~> 7.0.6"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem 'pagy'
gem 'kaminari'
gem 'will_paginate'
gem 'rubocop', require: false
gem 'byebug', '~> 9.0', '>= 9.0.6'
gem 'api-pagination'
gem 'hiredis'
gem 'maxmind-db'
gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'grape-swagger-entity'
gem 'grape_logging'
gem 'memoist'
gem 'jwt'
gem 'jwt-multisig'
gem 'email_validator'
gem 'countries', require: 'countries/global'
gem 'recaptcha'
gem "redis", "~> 4.0"
gem "bcrypt", "~> 3.1.7"
gem 'rack-cors'
gem 'rack-attack'
gem 'dotenv-rails'
gem 'colorize'
gem 'json-schema'
gem 'signet'
gem 'google-api-client'
gem 'googleauth'
gem 'rotp'
gem 'redis-rails'
gem 'connection_pool'
gem 'recaptcha'
gem 'bunny'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'grape_on_rails_routes', '~> 0.3.2'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

