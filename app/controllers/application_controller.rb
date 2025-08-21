class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  after_action :set_cable_cookie, if: :user_signed_in?

  private

  def set_cable_cookie
    cookies.encrypted[:user_id] = current_user.id if current_user
  end
end
