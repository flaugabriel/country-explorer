# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users::MultiFactorAuthenticationController', type: :request do
  include ApiHelpers

  let(:user) { create(:user) }
  let(:auth_headers) do
    login(user)
    get_auth_params_from_login_response_headers(response)
  end

  describe 'POST /users/enable_multi_factor_authentication' do
    context 'with a valid OTP token' do
      it 'enables MFA and returns 200' do
        otp = user.otp_code
        post '/users/enable_multi_factor_authentication',
             params: { id: user.id, otp_code_token: otp },
             headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(json['messager']).to eq('MFA ativado!')
        expect(user.reload.otp_module_enabled?).to be true
      end
    end

    context 'with an invalid OTP token' do
      it 'returns 422 with invalid token message' do
        post '/users/enable_multi_factor_authentication',
             params: { id: user.id, otp_code_token: '000000' },
             headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['messager']).to eq('Token invalido!')
      end
    end
  end

  describe 'POST /users/disable_multi_factor_authentication' do
    before { user.otp_module_enabled! }

    it 'disables MFA and returns 200' do
      post '/users/disable_multi_factor_authentication',
           params: { id: user.id },
           headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(json['messager']).to eq('MFA Desativado')
      expect(user.reload.otp_module_disabled?).to be true
    end
  end
end
