class NotificationsController < ApplicationController
  before_action :mark_notification_as_read_if_needed
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

  private

  def mark_notification_as_read_if_needed
    return unless params[:notification_id] && current_user
    notification = current_user.received_notifications.find_by(id: params[:notification_id])
    notification&.update(unread: false) if notification&.unread?
  end
end
