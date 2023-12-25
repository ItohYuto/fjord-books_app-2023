# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  has_many :mention_relationships, dependent: :destroy
  has_many :mentioning_reports, through: :mention_relationships, source: :mention
  has_many :reverse_of_relationships, class_name: 'MentionRelationship', foreign_key: 'mention_id', inverse_of: 'mention', dependent: :destroy
  has_many :mentioned_reports, through: :reverse_of_relationships, source: :report

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def mentions(target_reports)
    target_reports.map { |report| mention_relationships.find_or_create_by(mention_id: report.id) if self != report }.compact
  end

  def mention_cancels(target_reports)
    target_reports.map do |report|
      mention_relationship = mention_relationships.find_by(mention_id: report.id)
      mention_relationship&.destroy
    end
  end
end
