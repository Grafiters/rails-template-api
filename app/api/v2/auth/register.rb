module API
    module V2
        module Auth
            class Register < Grape::API
                namespace :register do
                    desc 'Register users'
                    params do
                        requires :email,
                                type: String,
                                desc: 'Email Users'
                        requires :password,
                                type: String,
                                desc: 'Password User'
                        optional :captcha,
                                type: Hash do
                                    requires :geetest_challenge,
                                            type: String,
                                            desc: 'Geetest Challenge'
                                    requires :geetest_seccode,
                                            type: String,
                                            desc: 'Geetest Seccode'
                        end
                    end
                    post do
                        declared_params = declared(params, include_missing: false )

                        present declared_params
                    end
                end

                namespace :google do
                    desc 'Auth by google user with response code from google auth'
                    params do
                        requires :code,
                                type: String,
                                desc: 'code from response redirect google auth'
                        requires :redirect_uri,
                                type: String,
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

                desc 'Activation Email'
                params do
                    requires :activation_token,
                        type: String,
                        desc: 'Email Activation'
                end
                get '/activate-email/:activation_token' do
                    user = User.find_by(email_verification_token: params[:activation_token])

                    error!({ errors: ['auth.user_not_found'] }, 422) unless user.present?

                    user.update(email_verified_at: Time.now)

                    present user
                end
            end
        end
    end
end