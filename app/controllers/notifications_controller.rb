class NotificationsController < ApplicationController
  def index
    @notifications = current_user.received_notifications.unread.order(created_at: :desc).page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def update
    @notification = current_user.received_notifications.find(params[:id])
    @notification.update(unread: false)
    respond_to do |format|
      format.html { redirect_to notifications_path }
      format.turbo_stream
    end
  end

  def mark_all_as_read
    current_user.received_notifications.destroy_all

    respond_to do |format|
      format.html { redirect_to notifications_path }
      format.turbo_stream
    end
  end
end
