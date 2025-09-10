class DogProfilesController < ApplicationController
  before_action :set_dog_profile, only: [ :edit, :update, :destroy]
  def new
    @dog_profile = current_user.dog_profiles.new
  end

  def create
    @dog_profile = current_user.dog_profiles.new(dog_profile_params)
    if @dog_profile.save
      redirect_to mypage_path, notice: "犬のプロフィールを追加しました🐶"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @dog_profile = DogProfile.find(params[:id])
  end

  def edit; end

  def update
    if @dog_profile.update(dog_profile_params)
      redirect_to mypage_path, notice: "犬のプロフィールを更新しました🐶"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @dog_profile.destroy!
    redirect_to mypage_path, notice: "犬のプロフィールを削除しました🦴"
  end

  private

  def set_dog_profile
    @dog_profile = current_user.dog_profiles.find(params[:id])
  end

  def dog_profile_params
    params.require(:dog_profile).permit(:name, :comehome_date, :birthday, :birthday_unknown, :age, :breed, :image)
  end
end
