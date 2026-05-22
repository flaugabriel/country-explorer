# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiConstraints do
  describe '#matches?' do
    context 'when default: true' do
      subject(:constraint) { described_class.new(version: 1, default: true) }

      it 'matches any request regardless of the Accept header' do
        request = instance_double(ActionDispatch::Request, headers: { 'Accept' => 'application/json' })
        expect(constraint.matches?(request)).to be true
      end
    end

    context 'when default: false' do
      subject(:constraint) { described_class.new(version: 1, default: false) }

      it 'matches when the Accept header includes the versioned media type' do
        request = instance_double(ActionDispatch::Request,
          headers: { 'Accept' => 'application/cnab-api.v1' })
        expect(constraint.matches?(request)).to be true
      end

      it 'does not match when the Accept header is for a different version' do
        request = instance_double(ActionDispatch::Request,
          headers: { 'Accept' => 'application/cnab-api.v2' })
        expect(constraint.matches?(request)).to be false
      end

      it 'does not match when the Accept header is a generic type' do
        request = instance_double(ActionDispatch::Request,
          headers: { 'Accept' => 'application/json' })
        expect(constraint.matches?(request)).to be false
      end
    end
  end
end
