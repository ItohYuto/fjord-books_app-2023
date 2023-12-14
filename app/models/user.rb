# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  validate :image_content_type, if: :was_attached?
  validate :image_size

  def image_content_type
    extension = ['image/png', 'image/jpg', 'image/jpeg', 'image/gif']
    errors.add(:image, 'の拡張子が間違っています') unless image.content_type.in?(extension)
  end

  def was_attached?
    image.attached?
  end

  def image_size
    errors.add(:image, '：1MB以下のファイルをアップロードしてください。') if image.attached? && image.blob.byte_size > 1.megabytes
  end
end
