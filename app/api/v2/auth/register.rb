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