require 'digest'
require 'net/http'

class GeetestService
  def initialize
    @api = 'http://api.geetest.com'
    @validate_path = '/validate.php'
    @register_path = '/register.php'
    @geetest_id = ENV.fetch('GEETEST_ID')
    @geetest_key = ENV.fetch('GEETEST_KEY')
  end

  def register
    challenge = get(@api + @register_path + "?gt=#{@geetest_id}")
    { gt: @geetest_id, challenge: Digest::MD5.hexdigest(challenge + @geetest_key) }
  rescue StandardError
    ''
  end
  
  def validate(response)
    md5 = Digest::MD5.hexdigest(@geetest_key + 'geetest' + response['geetest_challenge'])
    if response['geetest_validate'] == md5
      back = begin
               post(@api + @validate_path, seccode: response['geetest_seccode'])
             rescue StandardError
               ''
             end
      return back == Digest::MD5.hexdigest(response['geetest_seccode'])
    end
    false
  end

  private

  def get(uri)
    Net::HTTP.get_response(URI(uri)).body
  end

  def post(uri, data)
    Net::HTTP.post_form(URI(uri), data).body
  end
end