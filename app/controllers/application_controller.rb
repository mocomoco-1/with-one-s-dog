class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :sanitize_file_fields
  before_action :set_default_meta_tags
  after_action :set_cable_cookie, if: :user_signed_in?

  private

  def set_default_meta_tags
    set_meta_tags(helpers.default_meta_tags)
  end

  def set_cable_cookie
    cookies.encrypted[:user_id] = current_user.id if current_user
  end

  def sanitize_file_fields
    sanitize_files!(params)
  end

  def sanitize_files!(obj)
    case obj
    when ActionController::Parameters
      obj.each do |key, value|
        obj[key] = sanitize_files!(value)
      end
    when Array
      obj.reject(&:blank?).map { |v| sanitize_files!(v) }
    else
      obj
    end
  end
end
