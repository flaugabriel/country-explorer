# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::CountriesController, type: :controller do
  let(:user) { create(:user) }
  let(:token_headers) { user.create_new_auth_token }

  before do
    request.headers.merge!(token_headers)
  end

  describe 'GET #show' do
    context 'with country_name param' do
      it 'returns success and country data' do
        allow_any_instance_of(Countries::FetcherService).to receive(:call).and_return({ name: 'Brazil', cca2: 'BR' })
        get :show, params: { name: 'Brazil' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']['name']).to eq('Brazil')
      end
    end

    context 'with country_code param (cca2)' do
      it 'returns success and country data' do
        allow_any_instance_of(Countries::FetcherService).to receive(:call).and_return({ name: 'Vatican City', cca2: 'VA' })
        get :show, params: { name: 'VA' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']['cca2']).to eq('VA')
      end
    end

    context 'when country is not found' do
      it 'returns 404' do
        allow_any_instance_of(Countries::FetcherService).to receive(:call).and_raise(Countries::Errors::NotFound)
        get :show, params: { name: 'ZZZ' }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when external API times out' do
      it 'returns 503' do
        allow_any_instance_of(Countries::FetcherService).to receive(:call).and_raise(Countries::Errors::Timeout)
        get :show, params: { name: 'Brazil' }
        expect(response).to have_http_status(:service_unavailable)
      end
    end

    context 'when an unexpected error occurs' do
      it 'returns 500' do
        allow_any_instance_of(Countries::FetcherService).to receive(:call).and_raise(StandardError)
        get :show, params: { name: 'Brazil' }
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end
