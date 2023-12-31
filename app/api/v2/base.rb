require_relative '../base.rb'
require_relative 'template/base.rb'
require_relative 'auth/base.rb'
require_relative 'users/base.rb'
require_relative 'public/base.rb'
require_relative 'exceptions_handlers.rb'

module API
    module V2
       class Base < Grape::API
            API_VERSION = '/v2'
            
            format         :json
            default_format :json
            logger Rails.logger.dup
            logger.formatter = GrapeLogging::Formatters::Rails.new
            use GrapeLogging::Middleware::RequestLogger,
                logger:    logger,
                log_level: :debug,
                include:   [GrapeLogging::Loggers::Response.new,
                            GrapeLogging::Loggers::FilterParameters.new,
                            GrapeLogging::Loggers::ClientEnv.new,
                            GrapeLogging::Loggers::RequestHeaders.new]

            include API::V2::ExceptionHandlers

            mount V2::Template::Base => :template
            mount V2::Auth::Base => :auth
            mount V2::Users::Base => '/'
            mount V2::Public::Base => :public

            add_swagger_documentation base_path: File.join('/api', 'v2'),
                                consumes: ['application/json', 'application/x-www-form-urlencoded', 'multipart/form-data'],
                                add_base_path: true,
                                mount_path:  '/swagger',
                                api_version: API_VERSION,
                                security_definitions: {
                                  Bearer: {
                                    type: "apiKey",
                                    name: "JWT",
                                    in:   "header"
                                  }
                                }
            
       end
    end
end