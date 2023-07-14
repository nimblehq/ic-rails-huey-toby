# frozen_string_literal: true

module IcRailsHueyToby
  module Errors
    class Error < StandardError
      attr_reader :original_error

      def initialize(message = nil, original_error = nil)
        super(message)

        @original_error = original_error
      end
    end

    class SearchServiceError < StandardError; end

    class ParseServiceError < StandardError; end
  end
end
