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
    @profile = User.find_or_initialize_by(provider: provider, uid: uid)

    if @profile.new_record? || @profile.email.blank?
      email = @omniauth["info"]["email"].presence || "#{uid}-#{provider}@example.com"

      @profile.assign_attributes(
        email: email,
        name: @omniauth["info"]["name"],
        password: Devise.friendly_token[0, 20]
      )
      @profile.skip_confirmation! if provider == "line"
      @profile.save!
    end
    @profile.set_values(@omniauth)
    sign_in(:user, @profile)
    flash[:notice] = "ログインしました"
    redirect_to root_path
    # @user = User.find_or_create_by!(provider: provider, uid: uid) do |user|
    #   user.email = email
    #   user.name = info["name"]
    #   user.password = Devise.friendly_token[0, 20]
    # end
    # @user.set_values(@omniauth)
    # sign_in(:user, @user)
    # flash[:notice] = "ログインしました"
    # redirect_to root_path
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
