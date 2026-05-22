# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :country_code, :user_id, :user_email, :content, :likes_count, :dislikes_count, :created_at, :updated_at
  belongs_to :user, if: -> { object.user.present? }
end
