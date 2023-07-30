require_relative 'utils.rb'
require_relative 'register.rb'
require_relative 'login.rb'
require_relative 'utils.rb'

module API
    module V2
        module Auth
            class Base < Grape::API
                helpers API::V2::Auth::Utils

                mount Auth::Login
                mount Auth::Register
            end
        end
    end
end