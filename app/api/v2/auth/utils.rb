require_relative "#{Rails.root}/lib/redis_session.rb"
module API
    module V2
        module Auth
            module Utils
                def session
                    request.session
                end
    
                def open_session(user)
                    csrf_token = SecureRandom.hex(10)
                    expire_time = Time.now.to_i + 2.hours
                    session.merge!(
                      "uid": user.email,
                      "user_ip": remote_ip,
                      "user_agent": request.env['HTTP_USER_AGENT'],
                      "expire_time": expire_time,
                      "csrf_token": csrf_token
                    )
            
                    REDIS_POOL.with { |conn| conn.set("#{user.email}_session_data", session.to_json) }

                    csrf_token
                end
    
                def remote_ip
                    request.env['REMOTE_ADDR']
                def verify_captcha!(response:, error_statuses: [400, 422])
                    geetest(response: response)
                end

                def geetest(response:, error_statuses: [400, 422])
                    error!({ errors: ['identity.captcha.required'] }, error_statuses.first) if response.blank?
            
                    geetest_error_message = 'auth.captcha.verification_failed'

                    validate_geetest_response(response: response)
            
                    return if CaptchaService::GeetestVerifier.new.validate(response)
            
                    error!({ errors: [geetest_error_message] }, error_statuses.last)
                rescue StandardError
                    error!({ errors: [geetest_error_message] }, error_statuses.last)
                end
            end
        end
    end
end