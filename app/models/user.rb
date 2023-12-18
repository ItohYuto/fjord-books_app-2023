# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :profile, length: { maximum: 200 }
  validates :postal_code, format: { with: /\A\d{7}\z/, allow_blank: true }, on: :update
end
