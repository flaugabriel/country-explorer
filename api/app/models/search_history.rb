# frozen_string_literal: true

class SearchHistory < ApplicationRecord
  belongs_to :user

  validates :country_name, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
