ActionMailer::Base.smtp_settings = {
  address: ENV.fetch('SMTP_HOST'),
  port: ENV.fetch('SMTP_PORT'),
  user_name: ENV.fetch('SMTP_USER'),
  password: ENV.fetch('SMTP_PASS'),
  enable_starttls_auto: true
}