module API
    module V2
        module Utils
            extend Memoist
            def current_user
                @_current_user ||= User.find_by!(email: env[:current_payload]['email'])
            end

            memoize :current_user
        end
    end
end