class CustomDeviseMailer < Devise::Mailer
  default from: ENV["MAILGUN_FROM_EMAIL"]

  def headers_for(action, opts)
    {
      from: ENV["MAILGUN_FROM_EMAIL"],
      to: opts[:to],
      subject: opts[:subject]
    }
  end

def mail(headers = {}, &block)
    mg_client = Mailgun::Client.new(ENV["MAILGUN_API_KEY"])
    mail_body = render_to_string(template: template_path, layout: false)

    mg_client.send_message(ENV["MAILGUN_DOMAIN"],
      from: headers[:from],
      to: headers[:to],
      subject: headers[:subject],
      text: mail_body,   # plain textとしても使う
      html: mail_body    # HTMLメールとして送信
    )
  end
end
