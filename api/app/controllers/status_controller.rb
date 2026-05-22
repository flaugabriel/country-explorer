# frozen_string_literal: true

class StatusController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def index
    render json: {
      status: 'ok',
      version: '1.0',
      timestamp: Time.current.iso8601,
      environment: Rails.env
    }, status: :ok
  end
end
