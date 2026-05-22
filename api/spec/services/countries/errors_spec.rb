# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Countries::Errors do
  describe Countries::Errors::NotFound do
    it 'is a StandardError' do
      expect(described_class.ancestors).to include(StandardError)
    end

    it 'can be raised and caught' do
      expect { raise described_class }.to raise_error(Countries::Errors::NotFound)
    end
  end

  describe Countries::Errors::ExternalApiError do
    it 'is a StandardError' do
      expect(described_class.ancestors).to include(StandardError)
    end

    it 'can be raised and caught' do
      expect { raise described_class }.to raise_error(Countries::Errors::ExternalApiError)
    end
  end

  describe Countries::Errors::Timeout do
    it 'is a StandardError' do
      expect(described_class.ancestors).to include(StandardError)
    end

    it 'can be raised with a message' do
      expect { raise described_class, 'timed out' }.to raise_error(Countries::Errors::Timeout, 'timed out')
    end
  end
end
