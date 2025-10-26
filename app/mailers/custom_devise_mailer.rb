class CustomDeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: "devise/mailer"
  default from: "TOMONI <postmaster@tomoni-dogs.com>"

  def confirmation_instructions(record, token, opts = {})
    @token = token
    @resource = record
    @email = record.email
    mail(
      to: record.email,
      subject: "TOMONIアカウント認証のお願い",
      content_type: "multipart/alternative"
    ) do |format|
      format.html { render "devise/mailer/confirmation_instructions" }
      format.text { render "devise/mailer/confirmation_instructions" }
    end
  end

  def reset_password_instructions(record, token, opts = {})
    @token = token
    @resource = record
    @email = record.email
    mail(
      to: record.email,
      subject: "TOMONIパスワードリセットのご案内",
      content_type: "multipart/alternative"
    ) do |format|
      format.html { render "devise/mailer/reset_password_instructions" }
      format.text { render "devise/mailer/reset_password_instructions" }
    end
  end
end
