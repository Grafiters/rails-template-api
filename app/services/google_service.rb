require 'google/apis/oauth2_v2'
require 'google/apis/people_v1'

class GoogleService
  def initialize(params)
    @params = params
    @client = Signet::OAuth2::Client.new
    @oauth = Google::Apis::Oauth2V2::Oauth2Service.new
    @people = Google::Apis::PeopleV1::PeopleServiceService.new
  end

  def fetch_user
    @params[:access_token].present? ? user_info_with_access_token : user_info_with_code
  rescue => e
    Rails.logger.error e
    return false
  end

  private

  def person_field(data)
        {
            given_name: data.names[0].given_name,
            family_name: data.names[0].family_name,
            email: data.email_addresses[0].value,
            picture: data.photos[0].url,
            id: data.metadata.sources.first.id
        }
  end

  def user_info_with_access_token
    raw_user_data = @clientPeople.get_person('people/me', person_fields: 'names,emailAddresses,photos,metadata')
    person_field(raw_user_data)
  end

  def user_info_with_code
    signed_client_and_fetch_access_token
    @oauth.authorization = @client
    @oauth.get_userinfo
  end

  def signed_client_access_token
    @people.authorization = @params[:access_token]
    @people
  end

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