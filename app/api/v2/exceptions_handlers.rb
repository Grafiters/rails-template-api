module API::V2
  module ExceptionHandlers
    def self.included(base)
      base.instance_eval do
        rescue_from Grape::Exceptions::ValidationErrors do |e|
          errors_array = e.full_messages.map do |err|
            err.split.last
          end
          error!({ errors: errors_array }, 422)
        end

        rescue_from Grape::Exceptions::MethodNotAllowed do |_e|
          error!({ errors: 'server.method_not_allowed' }, 405)
        end

        rescue_from Grape::Exceptions::InvalidMessageBody do |_e|
          error!({ errors: 'server.method.invalid_message_body' }, 400)
        end

        rescue_from ActiveRecord::RecordNotFound do |_e|
          error!({ errors: ['record.not_found'] }, 404)
        end

        rescue_from ActionController::RoutingError do |_e|
          error!({ errors: ['route.not_matches'] }, 404)
        end

        rescue_from :all do |e|
          report_exception(e)
          error!({ errors: ['server.internal_error'] }, 417)
        end
      end
    end
end
    
end