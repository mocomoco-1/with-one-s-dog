class CommentsController < ApplicationController
  before_action :set_commentable, only: [ :create ]
  def create
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      respond_to do |f|
        f.turbo_stream
        f.html { redirect_to @commentable, notice: "コメントを投稿しました" }
      end
    else
      flash.now[:alert] = @comment.errors.full_messages.join(",")
      respond_to do |f|
        f.turbo_stream
        f.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_commentable
    if params[:consultation_id]
      @commentable = Consultation.find(params[:consultation_id])
    elsif params[:diary_id]
      @commentable = Diary.find(params[:diary_id])
    end
  end
end
