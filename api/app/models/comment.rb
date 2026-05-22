# frozen_string_literal: true


class Comment < ApplicationRecord
  # country_code deve ser sempre o ccn3 (3 dígitos)
  belongs_to :user, optional: true
  has_many :comment_likes, dependent: :destroy

  validates :country_code, presence: true, format: { with: /\A\d{3}\z/, message: 'deve ser o ccn3 (3 dígitos)' }
  validates :user_email, presence: true
  validates :content, presence: true, length: { minimum: 2 }

  scope :for_country, ->(code) { where(country_code: code) }
end
