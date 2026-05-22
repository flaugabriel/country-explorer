# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::CommentsController, type: :controller do
  let(:user) { User.create!(email: 'test@example.com', password: 'Password1!') }
  let!(:comment) { Comment.create!(country_code: '076', user: user, user_email: user.email, content: 'Ótimo país!') }

  describe 'GET #index' do
    it 'returns comments for a country' do
      get :index, params: { country_code: '076' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first['content']).to eq('Ótimo país!')
    end

    it 'returns bad request for invalid country_code format' do
      get :index, params: { country_code: 'BRA' }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to include('Country code must be a valid ccn3')
    end
  end

  describe 'POST #create' do
    let(:auth_headers) { user.create_new_auth_token }

    it 'creates a comment' do
      expect {
        request.headers.merge!(auth_headers)
        post :create, params: { country_code: '076', comment: { content: 'Novo comentário' } }
      }.to change(Comment, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns errors for invalid comment' do
      request.headers.merge!(auth_headers)
      post :create, params: { country_code: '076', comment: { content: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to be_present
    end

    it 'returns bad request for invalid country_code format' do
      request.headers.merge!(auth_headers)
      post :create, params: { country_code: 'BRA', comment: { content: 'Novo comentário' } }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to include('Country code must be a valid ccn3')
    end
  end
end
