# frozen_string_literal: true

class Books::CommentsController < ApplicationController
  include Commentable
  before_action :set_book, only: %i[create]

  def create
    add_comment(@book, comment_params)
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
