# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_country_code
      before_action :authenticate_user!, only: [:create]

      def index
        Rails.logger.info "[CommentsController] country_code recebido: \\#{@country_code}"
          unless @country_code.match?(/^\d{3}$/)
          render json: { error: 'Country code must be a valid ccn3 (3 digits)' }, status: :bad_request and return
        end
        comments = Comment.for_country(@country_code).order(created_at: :desc)
        render json: comments, each_serializer: CommentSerializer
      end

      def create
        Rails.logger.info "[CommentsController] country_code recebido (create): \\#{@country_code}"
          Rails.logger.info "[CommentsController] country_code recebido (create): \\#{@country_code} (tipo: \\#{@country_code.class}, inspect: \\#{@country_code.inspect})"
          unless @country_code.is_a?(String) && @country_code.match?(/^\d{3}$/)
            Rails.logger.error "[CommentsController] country_code inválido recebido: \\#{@country_code.inspect} (tipo: \\#{@country_code.class})"
            render json: { error: 'Country code must be a valid ccn3 (3 dígitos)' }, status: :bad_request and return
        end
        comment = Comment.new(comment_params)
        comment.user = current_user
        comment.user_email = current_user.email
        comment.country_code = @country_code
        Rails.logger.info "[CommentsController] Salvando comentário com country_code: \\#{comment.country_code.inspect}"
        if comment.save
          render json: comment, serializer: CommentSerializer, status: :created
        else
          Rails.logger.error "[CommentsController] Erro ao salvar comentário: \\#{comment.errors.full_messages.inspect}"
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_country_code
        @country_code = (params[:country_code] || params[:id]).to_s.strip
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end
