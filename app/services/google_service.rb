require 'google/apis/oauth2_v2'
class GoogleService
  def initialize(params)
    @params = params
    @client = Signet::OAuth2::Client.new
    @oauth = Google::Apis::Oauth2V2::Oauth2Service.new
  end

  def fetch_user
    signed_client_and_fetch_access_token
    @oauth.authorization = @client
    @oauth.get_userinfo
  rescue => e
    Rails.logger.error e
    return false
  end

  private

  def signed_client_and_fetch_access_token
    @client.client_id = ENV.fetch('GOOGLE_CLIENT_ID')
    @client.client_secret = ENV.fetch('GOOGLE_CLIENT_SECRET')
    @client.token_credential_uri = 'https://oauth2.googleapis.com/token'
    @client.redirect_uri = @params[:redirect_uri]
    @client.grant_type = 'authorization_code'
    @client.code = @params[:code]
    @client.fetch_access_token!
  end
end