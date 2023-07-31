module API
    module V2
        module Auth
            class Google < Grape::API
                namespace :google do
                    desc 'Auth by google user with response code from google auth'
                    params do
                        optional :access_token,
                                allow_blank: true,
                                type: String,
                                desc: 'Google access token'
                        optional :code,
                                type: String,
                                allow_blank: true,
                                desc: 'code from response redirect google auth'
                        optional :redirect_uri,
                                type: String,
                                allow_blank: true,
                                desc: 'Url from redirect get code'
                    end
                    post do
                        declared_params = declared(params, include_missing: false)
                        user_google = GoogleService.new(declared_params).fetch_user
                        if !user_google
                            error!({ errors: ['auth.google_service_error'] }, 417)
                        end
                        user = User.from_auth_google(user_google)

                        if User.count == 1
                            user.update(role: 'admin')
                        end

                        csrf_token = open_session(user)

                        response = {
                            status: true,
                            message: "Login berhasil.",
                            token: JwtService.new({users: user.as_fot_jwt_token}).encode_token,
                            csrf_token: csrf_token
                        }

                        present response
                    rescue => e
                        Rails.logger.warn e.inspect
                        error!({ errors: [e.as_json] }, 417)
                    end
                end
            end
        end
    end
end