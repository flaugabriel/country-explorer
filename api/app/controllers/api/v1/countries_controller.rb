# frozen_string_literal: true

module Api
  module V1
    class CountriesController < ApiController
      def show
        begin
          Rails.logger.info "[CountriesController] Param recebido: \\#{params[:name]}"
          param = params[:name]
          if param.match?(/^\\d{3}$/)
            Rails.logger.info "[CountriesController] Buscando por ccn3: \\#{param}"
            result = Countries::FetcherService.new(
              user: current_user,
              country_code: param
            ).call
          else
            Rails.logger.info "[CountriesController] Buscando por nome: \\#{param}"
            result = Countries::FetcherService.new(
              user: current_user,
              country_name: param
            ).call
          end
          render json: { data: result }, status: :ok
        rescue Countries::Errors::NotFound
          render json: { error: 'Country not found' }, status: :not_found
        rescue Countries::Errors::Timeout
          render json: { error: 'External service unavailable, please try again later' }, status: :service_unavailable
        rescue Countries::Errors::ExternalApiError
          render json: { error: 'Unexpected error' }, status: :internal_server_error
        rescue => e
          Rails.logger.error "[CountriesController] Erro inesperado: \\#{e.class} - \\#{e.message}\\n\\#{e.backtrace.join("\\n")}" 
          render json: { error: 'Unexpected error' }, status: :internal_server_error
        end
      end
    end
  end
end
