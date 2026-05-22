# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Countries::HttpClient do
  subject(:client) { described_class.new }

  let(:success_response) { instance_double(Faraday::Response, status: 200, success?: true, body: '{}') }

  describe '#get' do
    context 'when the request succeeds' do
      before do
        stub_request(:get, "https://restcountries.com/v3.1/name/Brazil?fields=test")
          .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a Faraday response object' do
        response = client.get('/v3.1/name/Brazil', { fields: 'test' })
        expect(response.status).to eq(200)
      end
    end

    context 'when a Faraday::TimeoutError is raised' do
      before { stub_request(:get, /restcountries\.com/).to_timeout }

      it 'raises Countries::Errors::Timeout' do
        expect { client.get('/v3.1/name/Brazil') }.to raise_error(Countries::Errors::Timeout)
      end
    end

    context 'when a Faraday::ConnectionFailed is raised' do
      before do
        stub_request(:get, /restcountries\.com/)
          .to_raise(Faraday::ConnectionFailed.new('connection refused'))
      end

      it 'raises Countries::Errors::Timeout with the original message' do
        expect { client.get('/v3.1/name/Brazil') }.to raise_error(Countries::Errors::Timeout, /connection refused/)
      end
    end
  end
end
