# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Countries::FetcherService do
  let(:user)      { create(:user) }
  let(:parser)    { Countries::ResponseParser.new }
  let(:persister) { instance_double(Countries::HistoryPersister, call: nil) }

  let(:parsed_data) do
    {
      name: 'Brazil', official_name: 'Federative Republic of Brazil',
      flag: 'https://flagcdn.com/br.png', flag_alt: 'Flag of Brazil',
      capital: 'Brasília', population: 214_000_000,
      currencies: ['Brazilian real (BRL)'], languages: ['Portuguese'],
      continent: 'South America', timezones: ['UTC-03:00'],
    }
  end

  let(:raw_payload) do
    [
      {
        'name'        => { 'common' => 'Brazil', 'official' => 'Federative Republic of Brazil' },
        'flags'       => { 'png' => 'https://flagcdn.com/br.png', 'alt' => 'Flag of Brazil' },
        'capital'     => ['Brasília'],
        'population'  => 214_000_000,
        'currencies'  => { 'BRL' => { 'name' => 'Brazilian real', 'symbol' => 'R$' } },
        'languages'   => { 'por' => 'Portuguese' },
        'continents'  => ['South America'],
        'timezones'   => ['UTC-03:00'],
      },
    ].to_json
  end

  # injeta um http_client dublê por padrão
  let(:http_client) { instance_double(Countries::HttpClient) }

  subject(:service) do
    described_class.new(
      user: user,
      country_name: 'Brazil',
      http_client: http_client,
      parser: parser,
      persister: persister
    )
  end

  describe '#call' do
    context 'when the external API returns a valid response' do
      let(:response) { instance_double(Faraday::Response, status: 200, success?: true, body: raw_payload) }

      before do
        allow(http_client).to receive(:get).and_return(response)
        Rails.cache.clear
      end

      it 'returns parsed country data with correct name' do
        expect(service.call[:name]).to eq('Brazil')
      end

      it 'returns parsed country data with correct capital' do
        expect(service.call[:capital]).to eq('Brasília')
      end

      it 'calls the persister with the country name' do
        service.call
        expect(persister).to have_received(:call).with('Brazil')
      end

      it 'caches the result (http_client called only once on second call)' do
        memory_store = ActiveSupport::Cache::MemoryStore.new
        allow(Rails).to receive(:cache).and_return(memory_store)
        service.call
        service.call
        expect(http_client).to have_received(:get).once
      end
    end

    context 'when the country is not found (404)' do
      let(:response) { instance_double(Faraday::Response, status: 404, success?: false, body: '{}') }

      before do
        allow(http_client).to receive(:get).and_return(response)
        Rails.cache.clear
      end

      it 'raises Countries::Errors::NotFound' do
        expect { service.call }.to raise_error(Countries::Errors::NotFound)
      end
    end

    context 'when the API returns an unexpected error status (500)' do
      let(:response) { instance_double(Faraday::Response, status: 500, success?: false, body: '{}') }

      before do
        allow(http_client).to receive(:get).and_return(response)
        Rails.cache.clear
      end

      it 'raises Countries::Errors::ExternalApiError' do
        expect { service.call }.to raise_error(Countries::Errors::ExternalApiError)
      end
    end

    context 'when the http_client raises Timeout' do
      before do
        allow(http_client).to receive(:get).and_raise(Countries::Errors::Timeout, 'timed out')
        Rails.cache.clear
      end

      it 'propagates Countries::Errors::Timeout' do
        expect { service.call }.to raise_error(Countries::Errors::Timeout)
      end
    end

    context 'when using the default persister (integration)' do
      before do
        stub_request(:get, /restcountries\.com/)
          .to_return(status: 200, body: raw_payload, headers: { 'Content-Type' => 'application/json' })
        Rails.cache.clear
      end

      it 'persists a search history record for the user' do
        service_with_real_deps = described_class.new(user: user, country_name: 'Brazil')
        expect { service_with_real_deps.call }.to change { user.search_histories.count }.by(1)
      end
    end
  end
end
