# frozen_string_literal: true

module Countries
  # Responsabilidade única: orquestra a busca de um país.
  # Dependency Inversion: recebe HttpClient, ResponseParser e HistoryPersister
  #   via construtor — nunca instancia dependências internamente sem padrão.
  class FetcherService
    CACHE_EXPIRY = 1.hour

    def initialize(user:, country_name:, http_client: HttpClient.new, parser: ResponseParser.new, persister: nil)
      @country_name = country_name.to_s.strip
      @http_client  = http_client
      @parser       = parser
      @persister    = persister || HistoryPersister.new(user: user)
    end

    def call
      data = fetch_with_cache
      @persister.call(@country_name)
      data
    end

    private

    def fetch_with_cache
      Rails.cache.fetch("countries:#{@country_name.downcase}", expires_in: CACHE_EXPIRY) do
        fetch_from_api
      end
    end

    def fetch_from_api
      response = @http_client.get(
        "/v3.1/name/#{URI.encode_www_form_component(@country_name)}",
        { fields: ResponseParser::FIELDS }
      )

      raise Countries::Errors::NotFound      if response.status == 404
      raise Countries::Errors::ExternalApiError unless response.success?

      @parser.call(JSON.parse(response.body).first)
    end
  end
end
