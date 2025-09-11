class ReactionsController < ApplicationController
  before_action :set_reactable
  def create
    @reaction = @reactable.reactions.find_or_initialize_by(user: current_user, reaction_category: params[:reaction_category])
    if @reaction.persisted?
      @reaction.destroy
    else
      @reaction.save
    end
    respond_to do |format|
      format.turbo_stream  # これを明示的に指定
      format.html { redirect_to @reactable }
    end
  end

  private

  def set_reactable
    if params[:consultation_id]
      @reactable = Consultation.find(params[:consultation_id])
    elsif params[:diary_id]
      @reactable = Diary.find(params[:diary_id])
    end
    Rails.logger.debug("DEBUG: set_reactable => #{@reactable.inspect}")
  end
end
