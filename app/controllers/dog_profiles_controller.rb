class DogProfilesController < ApplicationController
  before_action :set_user
  def new
    @dog_profile = @user.dog_profiles.new
  end

  def create
    @dog_profile = @user.dog_profiles.new(dog_profile_params)
    if @dog_profile.save
      logger.info "@dog_profile.image.attached?: #{@dog_profile.image.attached?}"
      redirect_to mypage_path, notice: "犬のプロフィールを追加しました🐶"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @dog_profile = @user.dog_profiles.find(params[:id])
  end

  def edit
    @dog_profile = @user.dog_profiles.find(params[:id])
  end

  def update
    @dog_profile = @user.dog_profiles.find(params[:id])
    if @dog_profile.update(dog_profile_params)
      logger.info "@dog_profile.image.attached?: #{@dog_profile.image.attached?}"
      redirect_to mypage_path, notice: "犬のプロフィールを更新しました🐶"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @dog_profile = @user.dog_profiles.find(params[:id])
    @dog_profile.destroy!
    redirect_to mypage_path, notice: "犬のプロフィールを削除しました🦴"
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def dog_profile_params
    params.require(:dog_profile).permit(:name, :comehome_date, :birthday, :birthday_unknown, :age, :breed, :image)
  end
end
