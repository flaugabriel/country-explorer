# frozen_string_literal: true

module Countries
  # Responsabilidade única: persiste o histórico de pesquisa do usuário.
  # Interface Segregation: expõe apenas #call como ponto de entrada público.
  class HistoryPersister
    def initialize(user:)
      @user = user
    end

    def call(country_name)
      @user.search_histories.create!(country_name: country_name.capitalize)
    rescue ActiveRecord::RecordInvalid
      nil
    end
  end
end
