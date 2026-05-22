# frozen_string_literal: true

class CommentLikeSerializer < ActiveModel::Serializer
  attributes :id, :comment_id, :user_id, :like, :created_at
end
