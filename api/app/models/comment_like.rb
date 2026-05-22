# frozen_string_literal: true

class CommentLike < ApplicationRecord
  belongs_to :comment
  belongs_to :user

  validates :like, inclusion: { in: [true, false] }
  validates :user_id, uniqueness: { scope: :comment_id }
end
