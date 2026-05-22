# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchHistory, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:country_name) }
  end

  describe '.recent scope' do
    before do
      user.search_histories.create!(country_name: 'Brazil')
      travel 1.second
      user.search_histories.create!(country_name: 'Argentina')
    end

    it 'returns records in descending creation order' do
      ordered = user.search_histories.recent.map(&:country_name)
      expect(ordered).to eq(%w[Argentina Brazil])
    end
  end
end
