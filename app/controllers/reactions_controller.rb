class ReactionsController < ApplicationController
  def create
    @consultation = Consultation.find(params[:consultation_id])
    @reaction = @consultation.reactions.find_or_initialize_by(user: current_user, reaction_category: params[:reaction_category])
    if @reaction.persisted?
      @reaction.destroy
    else
      @reaction.save
    end
    respond_to do |format|
      format.turbo_stream  # これを明示的に指定
      format.html { redirect_to @consultation }
    end
  end
end
