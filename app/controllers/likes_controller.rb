class LikesController < ApplicationController
  def create
    @comment = Comment.find(params[:comment_id])
    @like = @comment.likes.find_or_initialize_by(user: current_user)
    if @like.persisted?
      @like.destroy
    else
      @like.save
    end
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: root_path) }
    end
  end
end
