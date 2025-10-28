# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    basic_action
  end

  private

  def basic_action
    @omniauth = request.env["omniauth.auth"]
    return redirect_to root_path, alert: "認証情報が取得できませんでした" if @omniauth.blank?

    provider = @omniauth["provider"]
    uid = @omniauth["uid"]
    info = @omniauth["info"]

    email = info["email"].presence || "#{uid}-#{provider}@example.com"

    @user = User.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.email = email
      user.name = info["name"]
      user.password = Devise.friendly_token[0, 20]
    end

    sign_in(:user, @user)
    flash[:notice] = "ログインしました"
    redirect_to root_path
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
