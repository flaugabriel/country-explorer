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

    context 'when unlock_access! leaves errors on the user' do
      let(:errors) do
        ActiveModel::Errors.new(user).tap { |e| e.add(:base, 'cannot unlock') }
      end

      before do
        allow(User).to receive(:find_by).and_return(user)
        allow(user).to receive(:unlock_access!)
        allow(user).to receive(:errors).and_return(errors)
      end

      it 'returns 422 with errors' do
        get '/unlock/show', params: { unlock_token: user.email }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['erorrs']).to be_present
      end
    end
  end
end
