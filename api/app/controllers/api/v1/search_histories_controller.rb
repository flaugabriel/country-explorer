# frozen_string_literal: true

module Api
  module V1
    class SearchHistoriesController < ApiController
      def index
        histories = current_user.search_histories.recent.limit(20)
        render json: { data: histories.as_json(only: %i[id country_name created_at]) }, status: :ok
      end
    end
  end
end
