class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to consultation_path(comment.consultation), success: t("defaults.flash_message.created", item: Comment.model_name.human)
    else
      redirect_to consultation_path(comment.consultation), danger: t("defaults.flash_message.not_created", item: Comment.model_name.human)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(consultation_id: params[:consultation_id])
  end
end
