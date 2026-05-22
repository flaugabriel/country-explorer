# frozen_string_literal: true

module Api
  module V1
    class CommentLikesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_comment

      def create
        like = @comment.comment_likes.find_or_initialize_by(user: current_user)
        like.like = params[:like]
        if like.save
          update_counts
          render json: like, serializer: CommentLikeSerializer, status: :created
        else
          render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_comment
        @comment = Comment.find(params[:comment_id])
      end

      def update_counts
        @comment.update(
          likes_count: @comment.comment_likes.where(like: true).count,
          dislikes_count: @comment.comment_likes.where(like: false).count
        )
      end
    end
  end
end
