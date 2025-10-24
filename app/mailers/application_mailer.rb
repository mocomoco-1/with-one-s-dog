class ApplicationMailer < ActionMailer::Base
  default from: "TOMONI <postmaster@#{ENV['MAILGUN_DOMAIN']}>"
  layout "mailer"
end
