# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::CommentLikesController, type: :controller do
  let(:user) { User.create!(email: 'test@example.com', password: 'Password1!') }
  let(:comment) { Comment.create!(country_code: '076', user_email: 'a@a.com', content: 'Legal!') }

  let(:auth_headers) { user.create_new_auth_token }

  describe 'POST #create' do
    it 'likes a comment' do
      expect {
        request.headers.merge!(auth_headers)
        post :create, params: { comment_id: comment.id, like: true }
      }.to change(CommentLike, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(comment.reload.likes_count).to eq(1)
    end

    it 'dislikes a comment' do
      expect {
        request.headers.merge!(auth_headers)
        post :create, params: { comment_id: comment.id, like: false }
      }.to change(CommentLike, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(comment.reload.dislikes_count).to eq(1)
    end

    it 'updates like if already exists' do
      request.headers.merge!(auth_headers)
      post :create, params: { comment_id: comment.id, like: true }
      expect {
        post :create, params: { comment_id: comment.id, like: false }
      }.not_to change(CommentLike, :count)
      expect(comment.reload.likes_count).to eq(0)
      expect(comment.reload.dislikes_count).to eq(1)
    end

    it 'returns errors for invalid like' do
      request.headers.merge!(auth_headers)
      # Não envia o parâmetro :like, tornando inválido
      post :create, params: { comment_id: comment.id }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end
end
