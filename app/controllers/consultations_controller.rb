class ConsultationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  def index
    @consultations = Consultation.includes(:user).order(created_at: :desc)
  end

  def new
    @consultation = Consultation.new
  end

  def create
    @consultation = current_user.consultations.build(consultation_params)
    if @consultation.save
      redirect_to consultations_path, notice: t("defaults.flash_message.created", item: Consultation.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_created", item: Consultation.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @consultation = Consultation.find(params[:id])
    @comment = Comment.new
    @comments = @consultation.comments.includes(:user).order(created_at: :desc)
  end

  private

  def consultation_params
    params.require(:consultation).permit(:title, :content)
  end
end
