class CustomDeviseMailer < Devise::Mailer
  default from: ENV["MAILGUN_FROM_EMAIL"]
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: "devise/mailer"
  default from: "TOMONI <postmaster@tomoni-dogs.com>"
end
