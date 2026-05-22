# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Countries::HistoryPersister do
  let(:user) { create(:user) }

  subject(:persister) { described_class.new(user: user) }

  describe '#call' do
    context 'when the record is valid' do
      it 'creates a SearchHistory for the user' do
        expect { persister.call('brazil') }.to change { user.search_histories.count }.by(1)
      end

      it 'capitalizes the country name before saving' do
        persister.call('brazil')
        expect(user.search_histories.last.country_name).to eq('Brazil')
      end
    end

    context 'when the record is invalid (country_name blank after capitalize)' do
      it 'does not raise and returns nil' do
        allow(user.search_histories).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
        expect { persister.call('') }.not_to raise_error
        expect(persister.call('')).to be_nil
      end
    end
  end
end
