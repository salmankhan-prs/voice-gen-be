
Resend.api_key = ENV["RESEND_API_KEY"]

Rails.application.configure do
  config.action_mailer.delivery_method = :resend
  config.action_mailer.raise_delivery_errors = true
end
