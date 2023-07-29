class TotpService
  ISSUER_NAME = ENV.fetch('APP_NAME', 'nusablockcahin')
  def initialize(payload)
    @users = payload[:users]
    @totp_secret = payload[:totp_secret]
  end

  def generate_otp
    {url: initGenerateOtp.provisioning_uri(provisioning_url)}
  end

  def verify_otp(totp_code)
    @totp_code = totp_code
    result = verify
    write_last_otp_verify(result) if read_last_otp_verify.blank?
    result
  end

  private

  def verify
    ROTP::TOTP.new(@totp_secret).verify(@totp_code, after: read_last_otp_verify)
  end
  
  def write_last_otp_verify(verify_at)
    Rails.cache.write("verify_otp_#{@users[:email]}", verify_at,expires_in: 30.second)
  end

  def read_last_otp_verify
    Rails.cache.read("verify_otp_#{@users[:email]}")
  end
  
  def initGenerateOtp
    ROTP::TOTP.new(totp_secret: ROTP::Base32.random_base32, issuer: ISSUER_NAME, account_name: @users[:email])
  end
  
  def provisioning_url
    ENV.fetch('BASE_URL')
  end
end