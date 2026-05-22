# frozen_string_literal: true

module Countries
  # Responsabilidade única: executa chamadas HTTP à API externa.
  # Dependency Inversion: injetável como dependência no FetcherService.
  class HttpClient
    BASE_URL     = 'https://restcountries.com'
    TIMEOUT      = 5
    OPEN_TIMEOUT = 3

    def get(path, params = {})
      connection.get(path, params)
    rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
      raise Countries::Errors::Timeout, e.message
    end

    private

    def connection
      @connection ||= Faraday.new(BASE_URL) do |conn|
        conn.options.timeout      = TIMEOUT
        conn.options.open_timeout = OPEN_TIMEOUT
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
