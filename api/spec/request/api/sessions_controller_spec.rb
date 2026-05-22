# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users::SessionsController (MFA login)', type: :request do
  include ApiHelpers

  let(:user) { create(:user) }

  let(:auth_headers) do
    login(user)
    get_auth_params_from_login_response_headers(response)
  end

  describe 'POST /users/mfa' do
    context 'when MFA is disabled on the account' do
      it 'returns 200 with welcome message' do
        post '/users/mfa', params: {}, headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(json['messager']).to eq('Bem vindo!')
      end
    end

    context 'when MFA is enabled on the account' do
      before { user.otp_module_enabled! }

      context 'with a valid OTP token' do
        it 'returns 200 with welcome message' do
          otp = user.otp_code
          post '/users/mfa', params: { otp_code_token: otp }, headers: auth_headers
          expect(response).to have_http_status(:ok)
          expect(json['messager']).to eq('Bem vindo!')
        end
      end

      context 'with an invalid OTP token' do
        it 'returns 505 with invalid credentials message' do
          post '/users/mfa', params: { otp_code_token: '000000' }, headers: auth_headers
          expect(response.status).to eq(505)
          expect(json['messager']).to eq('Suas credenciais são invalidas.')
        end
      end

      context 'with a blank OTP token' do
        it 'returns 404 with missing token message' do
          post '/users/mfa', params: { otp_code_token: '' }, headers: auth_headers
          expect(response.status).to eq(404)
          expect(json['messager']).to eq('Sua conta precisa fornecer um token valido.')
        end
      end
    end
  end
end
