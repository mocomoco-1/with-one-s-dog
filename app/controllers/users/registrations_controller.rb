# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super do |resource|
      # エラーがある場合 resource.errors を flash にコピー
      if resource.errors.any?
        customize_email_errors(resource)
        flash.now[:alert] = resource.errors.full_messages.join(", ")
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # ユーザー新規登録時、許可するものにnameパラメータ追加
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # アカウント情報変更時のパラメーター
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  # The path used after sign up.
  # 新規登録後にリダイレクトされるパスを指定する。superだとデフォルトのリダイレクト先
  def after_sign_up_path_for(resource)
    root_path
  end

  # The path used after sign up for inactive accounts.
  # サインアップしたが、アカウントがアクティブでないときにリダイレクトされるパスを指定するメソッド
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end

  def customize_email_errors(resource)
    email_errors = resource.errors[:email]
    duplicate_patterns = [
      "taken",
      "already been taken",
      "has already been taken",
      "既に使用されています",
      "使用されています",
      "すでに存在します",
      "既に存在します"
    ]
    has_duplicate_error = email_errors.any? do |msg|
      duplicate_patterns.any? { |pattern| msg.include?(pattern) }
    end
    if has_duplicate_error
      resource.errors.delete(:email)
      resource.errors.add(:base, "登録できません。入力内容を確認してください。")
    end
  end
end
