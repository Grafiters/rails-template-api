require_relative 'user.rb'
require_relative '../utils.rb'
require_dependency 'middleware/jwt_authenticator'

module API
    module V2
        module Users
            class Base < Grape::API
                use Middleware::JWTAuthenticator

                helpers API::V2::Utils

                mount Users::User
            end
        end
    end
end