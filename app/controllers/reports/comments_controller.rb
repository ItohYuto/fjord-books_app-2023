# frozen_string_literal: true

class Reports::CommentsController < ApplicationController
  include Commentable
  before_action :set_report, only: %i[create]

  def create
    add_comment(@report, comment_params)
  end

  private

  def set_report
    @report = Report.find(params[:report_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
