# frozen_string_literal: true

module Search
  module Google
    class SearchService < Search::BaseService
      GOOGLE_SEARCH_BASE_URL = 'https://www.google.com/search'

      def initialize(keyword, language = 'en')
        super(keyword, language)
      end

      def call
        uri = URI.parse("#{GOOGLE_SEARCH_BASE_URL}?q=#{keyword}&hl=#{language}&lr=#{language}")

        response = Net::HTTP.get_response(uri)

        response.body if response.is_a?(Net::HTTPSuccess)
      end
    end
  end
end
