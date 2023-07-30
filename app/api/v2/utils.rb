require_relative '../../../lib/redis_session.rb'
module API
    module V2
        module Utils
            def session
                request.session
            end

            def current_user
                @_current_user ||= User.find_by!(email: env[:current_payload]['email'])
            end

            def remote_ip
                request.remote_ip
            end
        end
    end
end