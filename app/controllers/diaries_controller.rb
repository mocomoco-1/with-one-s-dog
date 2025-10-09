class DiariesController < ApplicationController
  def index
    @diaries = Diary.includes(:user).status_published.order(created_at: :desc).page(params[:page])
  end

  def my_diaries
    if params[:user_id].present? && params[:user_id].to_i != current_user.id
      @user = User.find(params[:user_id])
      @diaries = @user.diaries.status_published.order(created_at: :desc).page(params[:page])
    else
      @user = current_user
      @diaries = current_user.diaries.order(created_at: :desc).page(params[:page])
    end

    diary_events = @diaries.map do |d|
      {
        title: "🐾日記",
        start: d.created_at.to_date,
        url: diary_path(d),
        color: "#8CC9E2"
      }
    end
    profile_events = @user.dog_profiles.flat_map do |dog|
      events = []
      events << {
        title: "#{dog.name}🐶うちの子記念日",
        rrule: {
          freq: "yearly",
          dtstart: dog.comehome_date.to_s
        },
        color: "#FFD700"
      } if dog.comehome_date.present?
      events << {
        title: "#{dog.name}🎂誕生日",
        rrule: {
          freq: "yearly",
          dtstart: dog.birthday.to_s
        },
        color: "#ffc0cb"
      } if dog.birthday.present?
      events
    end
    @events = (diary_events + profile_events).to_json
  end

  def new
    @diary = Diary.new(params.fetch(:diary, {}).permit(:content))
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      DiaryImagesResizeJob.perform_later(@diary) if @diary.images.attached?
      redirect_to diary_path(@diary), notice: t("defaults.flash_message.created", item: Diary.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_created", item: Diary.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @diary = Diary.find(params[:id])
    unless @diary.status_published? || @diary.user == current_user
      redirect_to diaries_path, alert: "この日記は閲覧できません"
    end
    @commentable = @diary
    @comment = Comment.new
    @comments = @commentable.comments.includes(:user).order(created_at: :desc)
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
    DiaryImagesResizeJob.perform_later(@diary)
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
    params.require(:diary).permit(:written_on, :content, :status, images: [])
  end
end
