class TotpService
  ISSUER_OTP = ENV.fetch('APP_NAME', 'nusablockcahin')
  def initialize(params)
    @users = params
  end

  private
  def initGenerateOtp(issuer, data)
    ROTP::TOTP.new(, issuer: "My Service")
  end
end