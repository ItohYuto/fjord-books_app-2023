# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  has_many :forward_mentions, class_name: 'ReportMention', foreign_key: 'mention_to_id', inverse_of: 'mention_to', dependent: :destroy
  has_many :mentioning_reports, through: :forward_mentions, source: :mentioned_by
  has_many :backward_mentions, class_name: 'ReportMention', foreign_key: 'mentioned_by_id', inverse_of: 'mentioned_by', dependent: :destroy
  has_many :mentioned_reports, through: :backward_mentions, source: :mention_to

  after_create :create_mentions
  after_update :update_mentions

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def find_mention_reports
    report_ids = content.scan(%r{http://localhost:3000/reports/[0-9]*}).map { |url| url.delete_prefix('http://localhost:3000/reports/') }
    Report.where(id: report_ids).where.not(id:)
  end

  def add_mentions(target_reports)
    self.mentioning_reports += target_reports
  end

  def delete_mentions(target_reports)
    self.mentioning_reports -= target_reports
  end

  def create_mentions
    mention_reports = find_mention_reports
    add_mentions(mention_reports)
  end

  def update_mentions
    mention_reports = find_mention_reports
    delete_mentions(mentioning_reports - mention_reports)
    add_mentions(mention_reports - mentioning_reports)
  end
end
