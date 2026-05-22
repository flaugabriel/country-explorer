# frozen_string_literal: true

module Countries
  # Responsabilidade única: transforma o payload bruto da API em hash padronizado.
  # Open/Closed: pode ser estendido por subclasse sem modificar esta classe.
  class ResponseParser
    FIELDS = 'name,capital,population,currencies,languages,continents,timezones,flags'

    def call(raw)
      {
        name:          raw.dig('name', 'common'),
        official_name: raw.dig('name', 'official'),
        flag:          raw.dig('flags', 'png'),
        flag_alt:      raw.dig('flags', 'alt'),
        capital:       raw.dig('capital', 0),
        population:    raw['population'],
        currencies:    parse_currencies(raw['currencies']),
        languages:     raw['languages']&.values || [],
        continent:     raw.dig('continents', 0),
        timezones:     raw['timezones'] || [],
      }
    end

    private

    def parse_currencies(currencies_hash)
      return [] if currencies_hash.blank?

      currencies_hash.map { |code, info| "#{info['name']} (#{code})" }
    end
  end
end
