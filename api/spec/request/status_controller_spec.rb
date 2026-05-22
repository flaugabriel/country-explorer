# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StatusController', type: :request do
  include ApiHelpers

  describe 'GET /' do
    it 'returns health status payload' do
      get '/'

      expect(response).to have_http_status(:ok)
      expect(json['status']).to eq('ok')
      expect(json['version']).to eq('1.0')
      expect(json['environment']).to eq('test')
      expect(json['timestamp']).to be_present
    end
  end
end
