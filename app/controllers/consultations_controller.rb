class ConsultationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  def index
    @q = Consultation.ransack(params[:q])
    @consultations = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
    if params[:tag_name].present?
      @consultations = Consultation.tagged_with("#{params[:tag_name]}").order(created_at: :desc).page(params[:page])
      @selected_tag = params[:tag_name]
    end
    @tags = Consultation.tag_counts_on(:tags).most_used(20).order("count DESC")
  end

  def my_consultations
    if params[:user_id].present? && params[:user_id].to_i != current_user.id
      @user = User.find(params[:user_id])
      @consultations = @user.consultations.order(created_at: :desc).page(params[:page])
    else
      @user = current_user
      @consultations = current_user.consultations.order(created_at: :desc).page(params[:page])
    end
  end

  def new
    @consultation = Consultation.new
  end

  def create
    @consultation = current_user.consultations.build(consultation_params)
    if @consultation.save
      redirect_to consultation_path(@consultation), notice: t("defaults.flash_message.created", item: Consultation.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_created", item: Consultation.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @consultation = Consultation.find(params[:id])
    @commentable = @consultation
    @comment = Comment.new
    @comments = @commentable.comments.includes(:user).order(created_at: :desc)
    keywords = @consultation.title.split("")
    or_query = keywords.join(" | ")
    @similar_consultations = Consultation.search_similar(or_query).where.not(id: @consultation.id).limit(3)
  end

  def edit
    @consultation = current_user.consultations.find(params[:id])
  end

  def update
    @consultation = current_user.consultations.find(params[:id])
    if @consultation.update(consultation_params)
      redirect_to consultation_path(@consultation), notice: t("defaults.flash_message.updated", item: Consultation.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_updated", item: Consultation.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    consultation = current_user.consultations.find(params[:id])
    consultation.destroy!
    redirect_to consultations_path, notice: t("defaults.flash_message.deleted", item: Consultation.model_name.human)
  end

  private

  def consultation_params
    params.require(:consultation).permit(:title, :content, :tag_list)
  end
end
