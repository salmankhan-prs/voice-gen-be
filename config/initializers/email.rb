Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  smtp_port = ENV.fetch("SMTP_PORT", 587).to_i

  config.action_mailer.smtp_settings = {
    address: ENV.fetch("SMTP_ADDRESS", "email-smtp.us-east-1.amazonaws.com"),
    port: smtp_port,
    user_name: ENV["SMTP_USERNAME"],
    password: ENV["SMTP_PASSWORD"],
    authentication: :login,
    enable_starttls_auto: smtp_port == 587,
    ssl: smtp_port == 465,
    tls: smtp_port == 465
  }

  config.action_mailer.raise_delivery_errors = true
end
