# frozen_string_literal: true

class CommentsController < ApplicationController
  def destroy
    commentable = Comment.find(params[:id]).commentable
    redirect_to commentable if !comment = current_user.comments.find(params[:id])
    comment.destroy

    redirect_to commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end
end
