require_relative 'register.rb'
require_relative 'login.rb'
module API
    module V2
        module Auth
            class Base < Grape::API
                mount Auth::Register
                mount Auth::Login
            end
        end
    end
end