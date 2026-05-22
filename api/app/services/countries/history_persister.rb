# frozen_string_literal: true

module Countries
  # Responsabilidade única: persiste o histórico de pesquisa do usuário.
  # Interface Segregation: expõe apenas #call como ponto de entrada público.
  class HistoryPersister
    def initialize(user:)
      @user = user
    end

    def call(country_name)
      name = country_name.capitalize
      existing = @user.search_histories.find_by(country_name: name)
      if existing
        existing.touch
      else
        @user.search_histories.create!(country_name: name)
      end
    rescue ActiveRecord::RecordInvalid
      nil
    end
  end
end
