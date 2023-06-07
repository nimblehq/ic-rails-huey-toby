# frozen_string_literal: true

module Search
  class SearchService
    def initialize(search_engine:, keyword:, language: 'en')
      case search_engine
      when 'google'
        @search_service = Search::GoogleSearchService.new(keyword, language)
      else
        raise NotImplementedError, "Search engine #{search_engine} is not supported"
      end
    end

    def call
      uri = URI.parse(@search_service.search_url)

      response = Net::HTTP.get_response(uri)

      response.body if response.is_a?(Net::HTTPSuccess)
    end
  end
end
