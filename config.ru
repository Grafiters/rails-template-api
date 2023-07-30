# This file is used by Rack-based servers to start the application.
require 'grape'
require_relative "config/environment"

REDIS_POOL = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(url: 'redis://localhost:6379/0') }
use Rack::Session::Cookie, key: '_template_session', expire_after: 24.hours.to_i, same_site: :none, secure: false

run Rails.application
Rails.application.load_server
