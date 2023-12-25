# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    mention_reports = find_mention_reports(report_params[:content])
    is_success = ApplicationRecord.transaction do
      raise ActiveRecord::Rollback unless @report.save && @report.mentions(mention_reports).all?

      true
    end
    if is_success
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    mention_reports = find_mention_reports(report_params[:content])
    cancel_target_reports = @report.mentioning_reports - mention_reports
    add_target_reports = mention_reports - @report.mentioning_reports

    is_success = ApplicationRecord.transaction do
      update_report_success = @report.update(report_params)
      cancel_menntion_success = cancel_target_reports.empty? ? true : @report.mention_cancels(cancel_target_reports).all?
      add_menntion_success = add_target_reports.empty? ? true : @report.mentions(add_target_reports).all?
      raise ActiveRecord::Rollback unless update_report_success && cancel_menntion_success && add_menntion_success

      true
    end
    if is_success
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def find_mention_reports(content)
    report_ids = content.scan(%r{http://localhost:3000/reports/[0-9]*}).map { |url| url.delete_prefix('http://localhost:3000/reports/') }
    report_ids.map { |id| Report.find(id) if Report.where('id = ?', id).exists? }.compact
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
