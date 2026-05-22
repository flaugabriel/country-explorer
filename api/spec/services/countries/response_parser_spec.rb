# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Countries::ResponseParser do
  subject(:parser) { described_class.new }

  let(:full_raw) do
    {
      'name'        => { 'common' => 'Brazil', 'official' => 'Federative Republic of Brazil' },
      'flags'       => { 'png' => 'https://flagcdn.com/br.png', 'alt' => 'Flag of Brazil' },
      'capital'     => ['Brasília'],
      'population'  => 214_000_000,
      'currencies'  => { 'BRL' => { 'name' => 'Brazilian real', 'symbol' => 'R$' } },
      'languages'   => { 'por' => 'Portuguese' },
      'continents'  => ['South America'],
      'timezones'   => ['UTC-03:00'],
    }
  end

  describe '#call' do
    context 'with a complete payload' do
      it 'maps name correctly' do
        expect(parser.call(full_raw)[:name]).to eq('Brazil')
      end

      it 'maps official_name correctly' do
        expect(parser.call(full_raw)[:official_name]).to eq('Federative Republic of Brazil')
      end

      it 'maps flag correctly' do
        expect(parser.call(full_raw)[:flag]).to eq('https://flagcdn.com/br.png')
      end

      it 'maps capital correctly' do
        expect(parser.call(full_raw)[:capital]).to eq('Brasília')
      end

      it 'maps population correctly' do
        expect(parser.call(full_raw)[:population]).to eq(214_000_000)
      end

      it 'formats currencies as "Name (CODE)"' do
        expect(parser.call(full_raw)[:currencies]).to eq(['Brazilian real (BRL)'])
      end

      it 'maps languages as values array' do
        expect(parser.call(full_raw)[:languages]).to eq(['Portuguese'])
      end

      it 'maps continent correctly' do
        expect(parser.call(full_raw)[:continent]).to eq('South America')
      end

      it 'maps timezones correctly' do
        expect(parser.call(full_raw)[:timezones]).to eq(['UTC-03:00'])
      end
    end

    context 'when currencies is nil' do
      before { full_raw['currencies'] = nil }

      it 'returns an empty array for currencies' do
        expect(parser.call(full_raw)[:currencies]).to eq([])
      end
    end

    context 'when currencies is blank hash' do
      before { full_raw['currencies'] = {} }

      it 'returns an empty array for currencies' do
        expect(parser.call(full_raw)[:currencies]).to eq([])
      end
    end

    context 'when languages is nil' do
      before { full_raw['languages'] = nil }

      it 'returns an empty array for languages' do
        expect(parser.call(full_raw)[:languages]).to eq([])
      end
    end

    context 'when timezones is nil' do
      before { full_raw['timezones'] = nil }

      it 'returns an empty array for timezones' do
        expect(parser.call(full_raw)[:timezones]).to eq([])
      end
    end
  end

  describe '::FIELDS' do
    it 'contains all required fields' do
      %w[name capital population currencies languages continents timezones flags].each do |field|
        expect(described_class::FIELDS).to include(field)
      end
    end
  end
end
