# frozen_string_literal: true

class Books::CommentsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    comment = book.comments.build(comment_params)
    comment.user = current_user
    respond_to do |format|
      if comment.save
        format.html { redirect_to book_url(book), notice: t('controllers.common.notice_create', name: Book.model_name.human) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
