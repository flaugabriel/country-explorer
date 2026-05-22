# frozen_string_literal: true
# :nocov:

require 'rails_helper'
include ActionController::RespondWith

RSpec.describe Api::V1::MyaccountController, type: :request do
  let(:auth_headers) { create(:user).create_new_auth_token }


  describe '#profile' do
    context "when get profile" do
      it "gives you a data and status 200" do
        get '/api/myaccount/profile', params: { }, headers: auth_headers

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data'].class).to eq(Hash)
        expect(JSON.parse(response.body)['data']['email']).to eq(auth_headers['uid'])
      end
    end
  end

  describe 'GET #update' do
    context 'when update password whit correct params' do
      it 'gives you a status 200 on update and messager' do
        put '/api/myaccount/profile', params: 
        {
          user: { password: 'GN&03i4686#B', password_confirmation: 'GN&03i4686#B'}
        }, headers: auth_headers

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['message']).to eq('Senha atualizado, realize o login novamente!')
      end
    end

    context "when update password whit invalid params" do
      it 'gives error and status 422 and messager' do
        put '/api/myaccount/profile', params: 
        {
          user: { password: 'GN&03i4686#Z', password_confirmation: 'GN&03i4686#B'}
        }, headers: auth_headers

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['error']).to eq('Password confirmation não é igual a Password')
      end
    end
  end

  describe 'GET /api/myaccount/open_qrcode_mfa' do
    let(:blob) { instance_double(ActiveStorage::Blob, url: 'https://example.com/qr.png') }

    context 'when QrcodeCreateService builds a blob successfully' do
      before { allow_any_instance_of(QrcodeCreateService).to receive(:build).and_return(blob) }

      it 'returns 200 with the qrcode URL' do
        get '/api/myaccount/open_qrcode_mfa', headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['qrcode']).to eq('https://example.com/qr.png')
      end
    end

    context 'when QrcodeCreateService returns nil' do
      before { allow_any_instance_of(QrcodeCreateService).to receive(:build).and_return(nil) }

      it 'returns 200 with error fallback message' do
        get '/api/myaccount/open_qrcode_mfa', headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['qrcode']).to eq('Erro ao processar o QRCODE')
      end
    end
  end
end
