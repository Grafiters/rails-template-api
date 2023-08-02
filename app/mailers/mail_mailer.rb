class MailMailer < ApplicationMailer
    def mailer(params)
        @user = params[:user]
        @subject = params[:subject]
        @template = params[:template]
        @title = params[:title]

        option_params = {
            subject: @subject,
            template_name: @template,
            to: @user.email
        }

        mail(option_params)
    rescue => e
        Rails.logger.warn e.inspect
    end
end