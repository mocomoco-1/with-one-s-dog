require "mailgun-ruby"

class MailgunDelivery
  def initialize(options)
    @api_key = options[:api_key]
    @domain = options[:domain]
    @mg_client = Mailgun::Client.new(@api_key)
  end

  def deliver!(mail)
    message = {
      from: mail.from.first,
      to: mail.to.join(","),
      subject: mail.subject,
      text: mail.text_part&.body&.to_s,
      html: mail.html_part&.body&.to_s
    }
    @mg_client.send_message(@domain, message)
  end
end

if Rails.env.production?
  ActionMailer::Base.add_delivery_method :mailgun_custom, MailgunDelivery,
    api_key: ENV["MAILGUN_API_KEY"],
    domain: ENV["MAILGUN_DOMAIN"]
end