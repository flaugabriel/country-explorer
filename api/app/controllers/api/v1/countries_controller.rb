# frozen_string_literal: true

module Api
  module V1
    class CountriesController < ApiController
      def show
        result = Countries::FetcherService.new(
          user: current_user,
          country_name: params[:name]
        ).call

        render json: { data: result }, status: :ok
      rescue Countries::Errors::NotFound
        render json: { error: 'Country not found' }, status: :not_found
      rescue Countries::Errors::Timeout
        render json: { error: 'External service unavailable, please try again later' }, status: :service_unavailable
      rescue Countries::Errors::ExternalApiError, StandardError
        render json: { error: 'Unexpected error' }, status: :internal_server_error
      end
    end
  end
end
