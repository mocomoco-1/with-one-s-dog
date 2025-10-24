require "mailgun-ruby"

if Rails.env.production?
  ActionMailer::Base.add_delivery_method :mailgun_custom, MailgunDelivery,
    api_key: ENV["MAILGUN_API_KEY"],
    domain: ENV["MAILGUN_DOMAIN"]
end