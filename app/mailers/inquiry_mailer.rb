class InquiryMailer < ApplicationMailer
  default to: "tomoni.admin@tomoni-dogs.com"

  def send_inquiry(inquiry)
    @inquiry = inquiry
    mail(
      subject: "【TOMONI】お問い合わせが届きました",
      reply_to: @inquiry.email
    )
  end
end
