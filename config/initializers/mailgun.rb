require "mailgun-ruby"

class MailgunDelivery
  def initialize(options)
    @api_key = options[:api_key]
    @domain = options[:domain]
    @mg_client = Mailgun::Client.new(@api_key)
  end

  def deliver!(mail)
    text_body = mail.text_part&.body&.to_s
    html_body = mail.html_part&.body&.to_s

    # 両方nilなら全体のbodyを使う
    if text_body.blank? && html_body.blank?
      text_body = mail.body.to_s
    end

    message = {
      from: mail.from.first,
      to: mail.to.join(","),
      subject: mail.subject,
      text: text_body,
      html: html_body
    }

    begin
    @mg_client.send_message(@domain, message)
    rescue => e
      Rails.logger.error "[MailgunDelivery ERROR] #{e.message}"
      raise e
    end
  end
end
ActionMailer::Base.add_delivery_method :mailgun_custom, MailgunDelivery,
  api_key: ENV["MAILGUN_API_KEY"],
  domain: ENV["MAILGUN_DOMAIN"]
