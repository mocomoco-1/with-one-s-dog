class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update ]
  def show
    @dog_profiles = @user.dog_profiles
  end

  def edit
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def update
    if current_user.update(user_params)
      redirect_to mypage_path, notice: "マイページの内容を更新しました"
    else
      Rails.logger.debug current_user.errors.full_messages.inspect
      flash.now[:alert] = current_user.errors.full_messages.join(", ")
      render :edit
    end
  end

  def mypage
    @user = current_user
    @dog_profiles = @user.dog_profiles
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :image)
  end
end
