# frozen_string_literal: true

module Countries
  module Errors
    class NotFound < StandardError; end
    class ExternalApiError < StandardError; end
    class Timeout < StandardError; end
  end
end
