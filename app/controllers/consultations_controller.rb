class ConsultationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @consultations = Consultation.includes(:user)
  end
end
