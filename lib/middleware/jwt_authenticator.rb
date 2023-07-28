module Middleware
    # Authenticate a user by a bearer token
    class JWTAuthenticator < Grape::Middleware::Base
        def before
            return if request.path.include? 'swagger'

            raise 'Header Authorization missing' \
                unless authorization_present?

            token = request.headers['Authorization'].split(' ').last
            decode_token = JwtService.new(token).decode_token
            env[:current_payload] = decode_token
        end

        private

        def authorization_present?
            request.headers.key?('Authorization')
        end

        def request
            @request ||= Grape::Request.new(env)
        end
    end
end