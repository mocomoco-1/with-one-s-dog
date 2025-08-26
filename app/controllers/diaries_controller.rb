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

  def edit
    @diary = current_user.diaries.find(params[:id])
  end

  def update
    @diary = current_user.diaries.find(params[:id])
    if params[:diary][:image_ids].present?
      @diary.images.where(id: params[:diary][:image_ids]).find_each(&:purge)
    end
    if diary_params[:images].present?
    @diary.images.attach(diary_params[:images])
    end

    if @diary.update(diary_params.except(:images))
      redirect_to diary_path(@diary), notice: t("defaults.flash_message.updated", item: Diary.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_updated", item: Diary.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    diary = current_user.diaries.find(params[:id])
    diary.destroy!
    redirect_to diaries_path, notice: t("defaults.flash_message.deleted", item: Diary.model_name.human)
  end

  private

  def diary_params
    params.require(:diary).permit(:written_on, :content, images: [])
  end
end
