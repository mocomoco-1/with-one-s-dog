class DiariesController < ApplicationController
  def index
    @diaries = Diary.includes(:user).order(created_at: :desc)
  end

  def new
    @diary = Diary.new
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      redirect_to diary_path(@diary), notice: t("defaults.flash_message.created", item: Diary.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_created", item: Diary.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @diary = Diary.find(params[:id])
  end

  private

  def diary_params
    params.require(:diary).permit(:written_on, :content, :image)
  end
end
