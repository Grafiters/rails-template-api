module API
    module V2
        module Users
            class User < Grape::API
                namespace :users do
                    get :profile do
                        present current_user
                    end
                end
            end
        end
    end
end