module Middleware
    # Authenticate a user by a bearer token
    class JWTAuthenticator < Grape::Middleware::Base
        def before
            return if request.path.include? 'swagger'

            raise 'Header Authorization missing' \
                unless authorization_present?
                    
            raise "Header X-CSRF-token missing" \
                unless csrf_token?

            token = request.headers['Authorization'].split(' ').last
            @decode_token = JwtService.new(token).decode_token

            raise "Invalid CSRF Token" \
                    unless session_data && csrf_token_data == request.headers['X-Csrf-Token']

            env[:current_payload] = @decode_token
        end

        private

        def session_data
            REDIS_POOL.with { |conn| conn.get("#{@decode_token['email']}_session_data") }
        end

        def authorization_present?
            request.headers.key?('Authorization')
        end

        def csrf_token?
            request.headers['X-Csrf-Token'].present?
        end

        def request
            @request ||= Grape::Request.new(env)
        end

        def csrf_token_data
            csrf_token = nil
            parsed_data = JSON.parse(session_data)
            parsed_data.each do |subarray|
                if subarray[0] == "csrf_token"
                  csrf_token = subarray[1]
                  break
                end
            end
            
            csrf_token
        end
    end
end