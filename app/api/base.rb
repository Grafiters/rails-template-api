require_relative 'v2/base.rb'

module API
    class Base < Grape::API
        PREFIX = '/api'
        mount API::V2::Base => API::V2::Base::API_VERSION
    end
end