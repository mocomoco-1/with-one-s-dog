class Api::NotificationsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :verify_fastcron_token

  def send_anniversaries
    today = Date.today
    dog_profiles = DogProfile.includes(:user)
    dog_profiles.each do |dog|
      next unless dog.user.present?
      if dog.birthday_today?
        NotificationService.create(
          sender: nil,
          recipient: dog.user,
          notifiable: dog
        )
      elsif dog.anniversary_today?
        NotificationService.create(
          sender: nil,
          recipient: dog.user,
          notifiable: dog
        )
      end
    end
    render json: { status: "ok", date: today }
  end

  private

  def verify_fastcron_token
    unless params[:token] == ENV["FASTCRON_TOKEN"]
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
