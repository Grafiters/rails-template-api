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
                end
            end
        end
    end
end