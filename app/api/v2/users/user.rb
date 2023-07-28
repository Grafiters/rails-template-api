module API
    module V2
        module Users
            class User < Grape::API
                namespace :users do
                    get :profile do
                        Rails.logger.warn request.session
                        present current_user
                    end
                end
            end
        end
    end
end