# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    Rails.logger.info "=== LINE Callback Called ==="
    Rails.logger.info "Auth info: #{request.env['omniauth.auth']}"

    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      Rails.logger.info "User successfully created/found: #{@user.email}"
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "LINE") if is_navigational_format?
    else
      Rails.logger.error "User creation failed: #{@user.errors.full_messages}"
      session["devise.line_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: 'LINEアカウントでの登録に失敗しました。'
    end
  end

  def failure
    Rails.logger.error "OAuth failure: #{params[:message]}"
    redirect_to root_path, alert: 'ログインに失敗しました。再度お試しください。'
  end
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
