# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Countries::ResponseParser do
  subject(:parser) { described_class.new }

  let(:full_raw) do
    {
      'name'        => { 'common' => 'Brazil', 'official' => 'Federative Republic of Brazil' },
      'flags'       => { 'png' => 'https://flagcdn.com/br.png', 'alt' => 'Flag of Brazil' },
      'coatOfArms'  => { 'png' => 'https://mainfacts.com/media/images/coats_of_arms/br.png' },
      'capital'     => ['Brasília'],
      'population'  => 214_000_000,
      'area'        => 8515767,
      'region'      => 'Americas',
      'subregion'   => 'South America',
      'continents'  => ['South America'],
      'borders'     => ['ARG', 'BOL'],
      'maps'        => { 'googleMaps' => 'https://goo.gl/maps/waCKk21HeeqFzkNC9', 'openStreetMaps' => 'https://www.openstreetmap.org/relation/59470' },
      'timezones'   => ['UTC-03:00'],
      'currencies'  => { 'BRL' => { 'name' => 'Brazilian real', 'symbol' => 'R$' } },
      'languages'   => { 'por' => 'Portuguese' },
      'tld'         => ['.br'],
      'cca2'        => 'BR',
      'cca3'        => 'BRA',
      'ccn3'        => '076',
      'cioc'        => 'BRA',
      'idd'         => { 'root' => '+5', 'suffixes' => ['5'] },
      'demonyms'    => { 'eng' => { 'f' => 'Brazilian', 'm' => 'Brazilian' } },
      'gini'        => { '2019' => 53.4 },
      'startOfWeek' => 'sunday',
      'fifa'        => 'BRA',
      'car'         => { 'signs' => ['BR'], 'side' => 'right' },
      'latlng'      => [-10, -55],
    }
  end

  describe '#call' do
    context 'with a complete payload' do
            it 'maps coat_of_arms correctly' do
              expect(parser.call(full_raw)[:coat_of_arms]).to eq('https://mainfacts.com/media/images/coats_of_arms/br.png')
            end

            it 'maps area correctly' do
              expect(parser.call(full_raw)[:area]).to eq(8515767)
            end

            it 'maps region and subregion correctly' do
              expect(parser.call(full_raw)[:region]).to eq('Americas')
              expect(parser.call(full_raw)[:subregion]).to eq('South America')
            end

            it 'maps borders correctly' do
              expect(parser.call(full_raw)[:borders]).to eq(['ARG', 'BOL'])
            end

            it 'maps maps correctly' do
              expect(parser.call(full_raw)[:maps]).to eq({ 'googleMaps' => 'https://goo.gl/maps/waCKk21HeeqFzkNC9', 'openStreetMaps' => 'https://www.openstreetmap.org/relation/59470' })
            end

            it 'maps tld correctly' do
              expect(parser.call(full_raw)[:tld]).to eq('.br')
            end

            it 'maps ISO codes correctly' do
              expect(parser.call(full_raw)[:cca2]).to eq('BR')
              expect(parser.call(full_raw)[:cca3]).to eq('BRA')
              expect(parser.call(full_raw)[:ccn3]).to eq('076')
              expect(parser.call(full_raw)[:cioc]).to eq('BRA')
            end

            it 'maps idd correctly' do
              expect(parser.call(full_raw)[:idd]).to eq('+55')
            end

            it 'maps demonyms correctly' do
              expect(parser.call(full_raw)[:demonyms]).to eq('Brazilian')
            end

            it 'maps gini correctly' do
              expect(parser.call(full_raw)[:gini]).to eq(53.4)
            end

            it 'maps start_of_week correctly' do
              expect(parser.call(full_raw)[:start_of_week]).to eq('sunday')
            end

            it 'maps fifa correctly' do
              expect(parser.call(full_raw)[:fifa]).to eq('BRA')
            end

            it 'maps car correctly' do
              expect(parser.call(full_raw)[:car]).to eq({ signs: ['BR'], side: 'right' })
            end

            it 'maps latlng correctly' do
              expect(parser.call(full_raw)[:latlng]).to eq([-10, -55])
            end
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
