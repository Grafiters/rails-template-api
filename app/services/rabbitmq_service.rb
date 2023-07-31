class RabbitmqService
  def initialize(routing_key)
    @routing_key = routing_key
  end

  def handling_publish(record)
    configuration
    jwt_token = encode_payload(record)

    exchange_name = find_exchange(@queues_config['queues'].map { |q| q['bindings'][0] }, @routing_key)
    return if exchange_name.nil?

    exchange = channel.exchange(exchange_name, type: :direct)
    exchange.publish(jwt_token, routing_key: @routing_key)
  end

  def handling_publish_event(scope, user, event, payload)
    routing_key = [scope, user, event].join('.')
    serialized_data = JSON.dump(payload)
    channel.exchange('nusa.events.ranger', type: 'topic').publish(serialized_data, routing_key: routing_key)
  end

  private

  def encode_payload(payload)
    JwtService.new(payload).encode
  end

  def configuration
    @queues_config = YAML.load_file("#{Rails.root}/config/rabbitmq_channel.yml")
    channel_start
  end

  def channel_start
    @channel = Bunny.new(
        host: ENV.fetch("RABBITMQ_HOST"),
        port: ENV.fetch("RABBITMQ_PORT"),
        user: ENV.fetch("RABBITMQ_USERNAME"),
        pass: ENV.fetch("RABBITMQ_PASSWORD")
    ).start
  end

  def channel
    @channel.create_channel
  end

  def generated_payload(resource)
    resource.merge({
        iss: 'beautycare',
        iat: Time.now.to_i,
        exp: Time.now.to_i + 60,
        jti: SecureRandom.hex(10)
    })
  end

  def find_exchange(exchanges)
    exchanges.each do |exchange_config|
      exchange_name = exchange_config['exchange']

      return exchange_name if exchange_config['routing_key'] == @routing_key
    end
    nil
  end
end