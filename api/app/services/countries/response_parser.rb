# frozen_string_literal: true

module Countries
  # Responsabilidade única: transforma o payload bruto da API em hash padronizado.
  # Open/Closed: pode ser estendido por subclasse sem modificar esta classe.
  class ResponseParser
    FIELDS = 'name,capital,population,area,currencies,languages,continents,region,subregion,timezones,flags,coatOfArms,borders,tld,cca2,cca3,ccn3,cioc,idd,demonyms,gini,startOfWeek,fifa,car,latlng,maps'

    def call(raw)
      {
        name:           raw.dig('name', 'common'),
        official_name:  raw.dig('name', 'official'),
        flag:           raw.dig('flags', 'png'),
        flag_alt:       raw.dig('flags', 'alt'),
        coat_of_arms:   raw.dig('coatOfArms', 'png'),
        capital:        raw.dig('capital', 0),
        population:     raw['population'],
        area:           raw['area'],
        region:         raw['region'],
        subregion:      raw['subregion'],
        continent:      raw.dig('continents', 0),
        borders:        raw['borders'] || [],
        maps:           raw['maps'] || {},
        timezones:      raw['timezones'] || [],
        currencies:     parse_currencies(raw['currencies']),
        currencies_full: parse_currencies_full(raw['currencies']),
        languages:      raw['languages']&.values || [],
        tld:            raw['tld']&.first,
        cca2:           raw['cca2'],
        cca3:           raw['cca3'],
        ccn3:           raw['ccn3'],
        cioc:           raw['cioc'],
        idd:            parse_idd(raw['idd']),
        demonyms:       parse_demonyms(raw['demonyms']),
        gini:           parse_gini(raw['gini']),
        start_of_week:  raw['startOfWeek'],
        fifa:           raw['fifa'],
        car:            parse_car(raw['car']),
        latlng:         raw['latlng'],
      }
    end

    private

    def parse_currencies(currencies_hash)
      return [] if currencies_hash.blank?
      currencies_hash.map { |code, info| "#{info['name']} (#{code})" }
    end

    def parse_currencies_full(currencies_hash)
      return [] if currencies_hash.blank?
      currencies_hash.map do |code, info|
        {
          code: code,
          name: info['name'],
          symbol: info['symbol']
        }
      end
    end

    def parse_idd(idd_hash)
      return nil if idd_hash.blank?
      root = idd_hash['root']
      suffixes = idd_hash['suffixes'] || []
      return nil unless root
      suffixes.map { |s| "#{root}#{s}" }.join(', ')
    end

    def parse_demonyms(demonyms_hash)
      return nil if demonyms_hash.blank?
      eng = demonyms_hash['eng']
      return nil unless eng
      [eng['m'], eng['f']].uniq.compact.join(' / ')
    end

    def parse_gini(gini_hash)
      return nil if gini_hash.blank?
      gini_hash.values.first
    end

    def parse_car(car_hash)
      return nil if car_hash.blank?
      {
        signs: car_hash['signs'],
        side: car_hash['side']
      }
    end
  end
end
