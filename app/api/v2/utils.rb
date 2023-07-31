module API
    module V2
        module Utils
            def session
                request.session
            end

            extend Memoist
            def current_user
                @_current_user ||= User.find_by!(email: env[:current_payload]['email'])
            end

            def remote_ip
                request.remote_ip
            end
            memoize :current_user
        end
    end
end