# frozen_string_literal: true

class Reports::CommentsController < ApplicationController
  def create
    report = Report.find(params[:report_id])
    comment = report.comments.build(comment_params)
    comment.user = current_user
    respond_to do |format|
      if comment.save
        format.html { redirect_to report_url(report), notice: t('controllers.common.notice_create', name: Report.model_name.human) }
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
