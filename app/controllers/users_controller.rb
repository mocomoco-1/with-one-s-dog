class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update ]
  def show
  end

  def edit
    unless @user == current_user
      redirect_to user_path(@user)
    end
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(current_user), notice: "更新しました"
    else
      flash.now[:alert] = current_user.errors.full_messages.join(", ")
      render :edit
    end
  end

  def mypage
    redirect_to user_path(current_user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :image)
  end
end
