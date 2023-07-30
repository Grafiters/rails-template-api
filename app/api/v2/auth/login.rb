module API
    module V2
        module Auth
            class Login < Grape::API
                helpers do
                    def get_user(email)
                        user = User.find_by_email(email)
                        error!({error: ['auth.login.invalid_params']}, 401) unless user

                        error!({error: ['auth.login.user_not_active']}, 401) unless user.email_verified_at.present?

                        user
                    end
                end
                namespace :login do
                    desc 'Login with auth user'
                    params do
                        requires :email,
                            type: String,
                            desc: "Email from registered user"
                        requires :password,
                            type: String,
                            desc: "Password from registered user"
                        optional :otp_token,
                            type: String,
                            desc: 'Otp Token user'
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
                        verify_captcha!(response: params['captcha']) if params[:captcha].present?
                        user = get_user(params[:email])
                        present params
                    end
                end
            end
        end
    end
end