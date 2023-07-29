module API
    module V2
        module Auth
            module Utils
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