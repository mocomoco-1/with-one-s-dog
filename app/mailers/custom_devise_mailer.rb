class CustomDeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: "devise/mailer"
  default from: "TOMONI <postmaster@tomoni-dogs.com>"
end
