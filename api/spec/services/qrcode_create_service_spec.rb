# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QrcodeCreateService do
  let(:user) { create(:user) }
  let(:request) { instance_double(ActionDispatch::Request, base_url: 'http://test.host') }

  describe '#build' do
    it 'creates and uploads a PNG blob for MFA provisioning' do
      blob = described_class.new(user, request).build

      expect(blob).to be_a(ActiveStorage::Blob)
      expect(blob.content_type).to eq('image/png')
      expect(blob.filename.to_s).to eq('temp.png')
    end
  end
end
