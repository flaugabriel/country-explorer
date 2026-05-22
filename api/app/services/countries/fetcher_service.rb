# frozen_string_literal: true

module Countries
  # Responsabilidade única: orquestra a busca de um país.
  # Dependency Inversion: recebe HttpClient, ResponseParser e HistoryPersister
  #   via construtor — nunca instancia dependências internamente sem padrão.
  class FetcherService
    CACHE_EXPIRY = 1.hour

    # country_code deve ser sempre ccn3 (3 dígitos)
    def initialize(user:, country_name: nil, country_code: nil, http_client: HttpClient.new, parser: ResponseParser.new, persister: nil)
      @country_name = normalize_name(country_name)
      @country_code = country_code&.to_s&.strip
      @http_client  = http_client
      @parser       = parser
      @persister    = persister || HistoryPersister.new(user: user)
    end


    def call
      Rails.logger.info "[FetcherService] call iniciado - country_name: \\#{@country_name.inspect}, country_code: \\#{@country_code.inspect}"
      data = fetch_with_cache
      @persister.call(@country_name)
      data
    end

    private

    def normalize_name(name)
      return nil if name.nil?
      name.to_s.strip.downcase.gsub(/[-_]+/, ' ').gsub(/\s+/, ' ')
    end

    def fetch_with_cache
      key = @country_code ? "countries:code:#{@country_code.downcase}" : "countries:name:#{@country_name.downcase}"
      Rails.cache.fetch(key, expires_in: CACHE_EXPIRY) do
        fetch_from_api
      end
    end

    def fetch_from_api
      if @country_code
        Rails.logger.info "[FetcherService] Buscando por código: \\#{@country_code}"
        response = @http_client.get(
          "/v3.1/alpha/#{URI.encode_www_form_component(@country_code)}",
          { fields: ResponseParser::FIELDS }
        )
        Rails.logger.info "[FetcherService] Status: \\#{response.status}, Body: \\#{response.body}"
        raise Countries::Errors::NotFound      if response.status == 404
        raise Countries::Errors::ExternalApiError unless response.success?
        parsed = JSON.parse(response.body)
        country_data = parsed.is_a?(Array) ? parsed.first : parsed
        return @parser.call(country_data)
      end

      # Busca por nome
      Rails.logger.info "[FetcherService] Buscando por nome: \\#{@country_name}"
      response = @http_client.get(
        "/v3.1/name/#{URI.encode_www_form_component(@country_name)}",
        { fields: ResponseParser::FIELDS }
      )
      Rails.logger.info "[FetcherService] Status: \\#{response.status}, Body: \\#{response.body}"
      raise Countries::Errors::NotFound      if response.status == 404
      raise Countries::Errors::ExternalApiError unless response.success?
      parsed = JSON.parse(response.body)
      if parsed.is_a?(Array)
        # Normaliza nomes para comparação
        normalized_query = @country_name
        found = parsed.find do |c|
          names = [
            c.dig('name', 'common'),
            c.dig('name', 'official'),
            *(c.dig('altSpellings') || [])
          ].compact.map { |n| normalize_name(n) }
          names.include?(normalized_query)
        end
        raise Countries::Errors::NotFound unless found
        @parser.call(found)
      else
        @parser.call(parsed)
      end
    end
  end
end
