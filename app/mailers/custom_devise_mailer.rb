class CustomDeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: "devise/mailer"
  default from: "TOMONI <postmaster@tomoni-dogs.com>"
  def confirmation_instructions(record, token, opts = {})
    @token = token      # テンプレートで @token が使えるように
    @resource = record  # テンプレートで @resource が使えるように
    mail(to: record.email, subject: "TOMONI メールアドレス確認") do |format|
      format.html
      format.text
    end
  end
end
