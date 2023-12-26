# frozen_string_literal: true

module Commentable
  extend ActiveSupport::Concern

  def add_comment(commentable, comment_params)
    comment = commentable.comments.build(comment_params)
    comment.user = current_user
    if comment.save
      redirect_to url_for(commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to url_for(commentable), status: :unprocessable_entity
    end
  end
end
