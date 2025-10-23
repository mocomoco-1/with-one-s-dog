class CustomDeviseMailer < Devise::Mailer
  default from: ENV["MAILGUN_FROM_EMAIL"]

end
