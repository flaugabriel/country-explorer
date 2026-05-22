# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments API', type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'Password1!') }
  let!(:comment) { Comment.create!(country_code: '076', user: user, user_email: user.email, content: 'Ótimo país!') }

  describe 'GET /api/countries/:country_code/comments' do
    it 'returns comments for a country' do
      get "/api/countries/076/comments"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first['content']).to eq('Ótimo país!')
    end
  end

  describe 'POST /api/countries/:country_code/comments' do
    before do
      post '/api/auth/sign_in', params: { email: user.email, password: 'Password1!' }
      @auth_headers = response.headers.slice('client', 'access-token', 'uid', 'token-type')
    end

    it 'creates a comment' do
      expect {
        post "/api/countries/076/comments", params: { comment: { content: 'Novo comentário' } }, headers: @auth_headers
      }.to change(Comment, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns errors for invalid comment' do
      post "/api/countries/076/comments", params: { comment: { content: '' } }, headers: @auth_headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end
end
