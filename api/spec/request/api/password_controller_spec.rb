# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PasswordController', type: :request do
  include ApiHelpers

  let(:user) { create(:user) }

  describe 'POST /password/forgot' do
    context 'when email is blank' do
      it 'returns an error message' do
        post '/password/forgot', params: { email: '' }
        expect(json['error']).to eq('Email not present')
      end
    end

    context 'when email belongs to an existing user' do
      before { ActionMailer::Base.deliveries.clear }

      it 'returns status 200' do
        post '/password/forgot', params: { email: user.email }
        expect(response).to have_http_status(:ok)
      end

      it 'returns ok status in body' do
        post '/password/forgot', params: { email: user.email }
        expect(json['status']).to eq('ok')
      end

      it 'sends a reset password email' do
        post '/password/forgot', params: { email: user.email }
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end

    context 'when email does not belong to any user' do
      it 'returns 404' do
        post '/password/forgot', params: { email: 'nonexistent@example.com' }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        post '/password/forgot', params: { email: 'nonexistent@example.com' }
        expect(json['error'].first).to include('Email address not found')
      end
    end
  end

  describe 'POST /password/reset' do
    context 'when email param is blank' do
      it 'returns an error message' do
        post '/password/reset', params: { token: 'sometoken', email: '', password: 'New@Pass123' }
        expect(json['error']).to eq('Token not present')
      end
    end

    context 'when token is valid and not expired' do
      before { user.generate_password_token! }

      it 'returns status 200' do
        post '/password/reset', params: {
          email: user.email,
          token: user.reset_password_token,
          password: 'GN&03i4686#Z',
        }
        expect(response).to have_http_status(:ok)
      end

      it 'returns ok in body' do
        post '/password/reset', params: {
          email: user.email,
          token: user.reset_password_token,
          password: 'GN&03i4686#Z',
        }
        expect(json['status']).to eq('ok')
      end
    end

    context 'when reset_password! returns false' do
      before do
        user.generate_password_token!
        allow(User).to receive(:find_by).with(reset_password_token: user.reset_password_token).and_return(user)
        allow(user).to receive(:reset_password!).and_return(false)
        allow(user).to receive_message_chain(:errors, :full_messages).and_return(['Password is invalid'])
      end

      it 'returns 422 with validation errors' do
        post '/password/reset', params: {
          email: user.email,
          token: user.reset_password_token,
          password: 'GN&03i4686#Z',
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['error']).to eq(['Password is invalid'])
      end
    end

    context 'when token is invalid or expired' do
      it 'returns 404' do
        post '/password/reset', params: {
          email: user.email,
          token: 'invalidtoken',
          password: 'GN&03i4686#Z',
        }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        post '/password/reset', params: {
          email: user.email,
          token: 'invalidtoken',
          password: 'GN&03i4686#Z',
        }
        expect(json['error']).to match(/Link not valid or expired/)
      end
    end
  end
end
