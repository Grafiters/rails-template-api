class ApplicationMailer < ActionMailer::Base
  sender = "#{ENV.fetch('SENDER_NAME')} <#{ENV.fetch('EMAIL_FROM')}>"
  default from: sender
  layout "mailer"
end
