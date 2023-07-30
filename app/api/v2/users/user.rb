module API
    module V2
        module Users
            class User < Grape::API
                namespace :users do
                    get :profile do
                        present current_user
                    end

                    get '/generate-2fa' do
                        TotpService.new({users: current_user}).generate_otp
                    end

                    desc 'OTP Enabling for users'
                    params do
                        requires :otp_secret,
                                type: String,
                                desc: 'OTP Secret to enable'
                        requires :otp_code,
                                type: String,
                                desc: 'Code otp code to enable'
                    end
                    post '/enable-2fa' do
                        verify = TotpService.new({users: current_user, totp_secret: params[:otp_secret]}).verify_otp(params[:otp_code])
                        error!({
                            status: false,
                            message: 'otp_code is already use or invalid otp'
                        }) if verify.nil?

                        current_user.update({otp_secret: params[:otp_secret], otp_enabled: true})
                        response = {
                            status: true,
                            message: 'otp is enabled',
                            data: current_user
                        }

                        present response
                    end
                end
            end
        end
    end
end