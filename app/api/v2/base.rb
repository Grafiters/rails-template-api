require_relative '../base.rb'
require_relative 'template/base.rb'
require_relative 'exceptions_handlers.rb'

module API
    module V2
       class Base < Grape::API
            API_VERSION = '/v2'

            format         :json
            content_type   :json, 'multipart/form-data'
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

                                # info: {
                                #   title:         "Nagap2p User API #{API_VERSION}",
                                #   description:   'API for p2p platform application.',
                                #   contact_name:  'nagap2p.co.id',
                                #   contact_email: 'hello@nagap2p.co.id',
                                #   contact_url:   'https://dev.heavenexchange.io',
                                # },
            
       end
    end
end