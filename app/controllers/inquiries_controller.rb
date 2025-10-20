class InquiriesController < ApplicationController
  skip_before_action :authenticate_user!
  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      redirect_to new_inquiry_path, notice: "お問い合わせを送信しました。メールで返信いたします。しばらくお待ちください。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :phone_number, :message)
  end
end
