# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/countries/:name', type: :request do
  include ApiHelpers

  let(:user) { create(:user) }
  let(:auth_headers) do
    login(user)
    get_auth_params_from_login_response_headers(response)
  end

  let(:brazil_payload) do
    [
      {
        'name'        => { 'common' => 'Brazil', 'official' => 'Federative Republic of Brazil' },
        'flags'       => { 'png' => 'https://flagcdn.com/br.png', 'alt' => 'Flag of Brazil' },
        'capital'     => ['Brasília'],
        'population'  => 214_000_000,
        'currencies'  => { 'BRL' => { 'name' => 'Brazilian real', 'symbol' => 'R$' } },
        'languages'   => { 'por' => 'Portuguese' },
        'continents'  => ['South America'],
        'timezones'   => ['UTC-05:00', 'UTC-04:00', 'UTC-03:00', 'UTC-02:00'],
      },
    ].to_json
  end

  before { Rails.cache.clear }

  context 'when authenticated' do
    context 'when the country exists' do
      before do
        stub_request(:get, /restcountries\.com/)
          .to_return(status: 200, body: brazil_payload, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns 200 with country data' do
        get '/api/countries/brazil', headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(json['data']['name']).to eq('Brazil')
      end

      it 'includes capital in the response' do
        get '/api/countries/brazil', headers: auth_headers
        expect(json['data']['capital']).to eq('Brasília')
      end

      it 'includes continent in the response' do
        get '/api/countries/brazil', headers: auth_headers
        expect(json['data']['continent']).to eq('South America')
      end

      it 'creates a search history record' do
        expect { get '/api/countries/brazil', headers: auth_headers }.to change(SearchHistory, :count).by(1)
      end
    end

    context 'when the country does not exist (404 from external API)' do
      before do
        stub_request(:get, /restcountries\.com/)
          .to_return(status: 404, body: '{}', headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns 404' do
        get '/api/countries/unknowncountryxyz', headers: auth_headers
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        get '/api/countries/unknowncountryxyz', headers: auth_headers
        expect(json['error']).to eq('Country not found')
      end
    end

    context 'when the external API times out' do
      before { stub_request(:get, /restcountries\.com/).to_timeout }

      it 'returns 503' do
        get '/api/countries/brazil', headers: auth_headers
        expect(response).to have_http_status(:service_unavailable)
      end

      it 'returns a user-friendly error message' do
        get '/api/countries/brazil', headers: auth_headers
        expect(json['error']).to match(/unavailable/)
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow_any_instance_of(Countries::FetcherService).to receive(:call).and_raise(StandardError, 'boom')
      end

      it 'returns 500' do
        get '/api/countries/brazil', headers: auth_headers
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'returns a generic error message' do
        get '/api/countries/brazil', headers: auth_headers
        expect(json['error']).to eq('Unexpected error')
      end
    end
  end

  context 'when unauthenticated' do
    it 'returns 401' do
      get '/api/countries/brazil'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

RSpec.describe 'GET /api/search_histories', type: :request do
  include ApiHelpers

  let(:user) { create(:user) }
  let(:auth_headers) do
    login(user)
    get_auth_params_from_login_response_headers(response)
  end

  before do
    user.search_histories.create!(country_name: 'Brazil')
    user.search_histories.create!(country_name: 'Argentina')
  end

  context 'when authenticated' do
    it 'returns 200' do
      get '/api/search_histories', headers: auth_headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns the user search history' do
      get '/api/search_histories', headers: auth_headers
      expect(json['data'].length).to eq(2)
    end

    it 'includes country names in the response' do
      get '/api/search_histories', headers: auth_headers
      names = json['data'].map { |h| h['country_name'] }
      expect(names).to include('Brazil', 'Argentina')
    end
  end

  context 'when unauthenticated' do
    it 'returns 401' do
      get '/api/search_histories'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
