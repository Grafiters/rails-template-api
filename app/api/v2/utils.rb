module API
    module V2
        module Utils
            def current_user
                @_current_user ||= User.find_by!(email: env[:current_payload]['email'])
            end
        end
    end
end