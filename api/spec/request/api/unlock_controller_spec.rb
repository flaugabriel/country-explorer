# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UnlockController', type: :request do
  include ApiHelpers

  let(:user) { create(:user) }

  describe 'GET /unlock/show' do
    context 'when account is locked and token is valid' do
      before { user.lock_access! }

      it 'unlocks the account and returns 200' do
        get '/unlock/show', params: { unlock_token: user.email }
        expect(response).to have_http_status(:ok)
      end

      it 'returns ok status in body' do
        get '/unlock/show', params: { unlock_token: user.email }
        expect(json['status']).to eq('ok')
      end
    end

    context 'when account is not locked' do
      it 'still returns 200 (unlock_access! is idempotent)' do
        get '/unlock/show', params: { unlock_token: user.email }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
