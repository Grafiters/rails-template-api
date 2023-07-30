begin
    redis_url = ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')
    r = Redis.new(url: redis_url)
    r.ping
  rescue Redis::CannotConnectError
    Rails.logger.fatal("Error connecting to Redis on #{redis_url} (Errno::ECONNREFUSED)")
    raise 'FATAL: connection to Redis refused'
  end