module API
    module V2
        module Public
            class Geetest < Grape::API
                namespace :geetest do
                    get :register do
                        GeetestService.new.register
                    end
                end
            end
        end
    end
end