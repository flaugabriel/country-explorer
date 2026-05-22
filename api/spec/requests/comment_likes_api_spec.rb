# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CommentLikes API', type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'Password1!') }
  let!(:comment) { Comment.create!(country_code: '076', user: user, user_email: user.email, content: 'Ótimo país!') }

  before do
    post '/api/auth/sign_in', params: { email: user.email, password: 'Password1!' }
    @auth_headers = response.headers.slice('client', 'access-token', 'uid', 'token-type')
  end

  it 'likes a comment' do
    post "/api/comments/#{comment.id}/like", params: { like: true }, headers: @auth_headers
    expect(response).to have_http_status(:created)
    expect(comment.reload.likes_count).to eq(1)
  end

  it 'dislikes a comment' do
    post "/api/comments/#{comment.id}/like", params: { like: false }, headers: @auth_headers
    expect(response).to have_http_status(:created)
    expect(comment.reload.dislikes_count).to eq(1)
  end

  it 'updates like if already exists' do
    post "/api/comments/#{comment.id}/like", params: { like: true }, headers: @auth_headers
    post "/api/comments/#{comment.id}/like", params: { like: false }, headers: @auth_headers
    expect(comment.reload.likes_count).to eq(0)
    expect(comment.reload.dislikes_count).to eq(1)
  end
end
