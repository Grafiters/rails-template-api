require 'jwt'

class JwtService
  def initialize(payload)
    @payload = payload
  end

  def encode_token
    encode
  end

  def decode_token
    decode.first['users']
  end
  
  private

  def encode
    JWT.encode(merge_payload, private_key, jwt_algorithm)
  end

  def decode
    begin
      JWT.decode(@payload, public_key, true, { algorithm: jwt_algorithm })
    rescue JWT::ExpiredSignature, JWT::DecodeError => e
      return {
        status: false,
        message: e
      }
    end
  end

  def private_key
    begin
        file = "#{Rails.root}/#{ENV.fetch('JWT_PRIVATE_KEY')}"
        OpenSSL::PKey::RSA.new(File.read(file))
    rescue
        OpenSSL::PKey.read(Base64.urlsafe_decode64(ENV.fetch('JWT_PRIVATE_KEY')))
    end
  end

  def public_key
      begin
          file = "#{Rails.root}/#{ENV.fetch('JWT_PUBLIC_KEY')}"
          OpenSSL::PKey::RSA.new(File.read(file))
      rescue
          OpenSSL::PKey.read(Base64.urlsafe_decode64(ENV.fetch('JWT_PUBLIC_KEY')))
      end
  end

  def merge_payload
    @payload.merge({
        sub: 'session',
        aud: %['backend'],
        iss: issuer,
        iat: Time.now.to_i,
        exp: Time.now.to_i + 10.hour.to_i,
        jti: SecureRandom.hex(10)
    })
  end

  def issuer
    ENV.fetch('APP_NAME', 'nusablockchain')
  end

  def jwt_algorithm
    ENV.fetch('JWT_ALGORITHM', 'RS256')
  end
end