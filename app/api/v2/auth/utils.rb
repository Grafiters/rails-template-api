# require_relative "#{Rails.root}/lib/redis_session.rb"
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

                def geetest(response:, error_statuses: [400, 422])
                    error!({ errors: ['identity.captcha.required'] }, error_statuses.first) if response.blank?
            
                    geetest_error_message = 'auth.captcha.verification_failed'

                    validate_geetest_response(response: response)
            
                    return if CaptchaService::GeetestVerifier.new.validate(response)
            
                    error!({ errors: [geetest_error_message] }, error_statuses.last)
                rescue StandardError
                    error!({ errors: [geetest_error_message] }, error_statuses.last)
                end

                def publish_session_create(payload)
                    @user = payload
                    MailMailer.mailer(mailer_option('Login', 'New Login', 'login')).deliver_now
                    # RabbitmqService.new('mailer.send_email').handling_publish({record: record_data_user})
                end

                def send_code_regist(payload)
                    @user = payload
                    MailMailer.mailer(mailer_option('Activation Code', 'Activation Code', 'send_code')).deliver_now
                    # RabbitmqService.new('mailer.send_email').handling_publish({record: record_data_user})
                end

                def resend_code_regist(payload)
                    @user = payload
                    MailMailer.mailer(mailer_option('Resend Activation Code', 'Resend Activation Code', 'resend_code')).deliver_now
                    # RabbitmqService.new('mailer.send_email').handling_publish({record: record_data_user})
                end

                

                def remote_ip
                    request.env['REMOTE_ADDR']
                end

                def verify_captcha!(response:, error_statuses: [400, 422])
                    geetest(response: response)
                end

                def mailer_option(subject, title, template)
                    {
                        user: @user,
                        subject: subject,
                        template: template,
                        title: title
                    }
                end

                def record_data_user
                    {
                        email: @user.email,
                        google_id: @user.google_id,
                        ip_address: remote_ip,
                        device: request.env['HTTP_USER_AGENT'],
                        login_time: Time.now
                    }
                end
            end
        end
    end
end