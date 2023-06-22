# frozen_string_literal: true

module Search
  class BingSearchService
    BING_SEARCH_URL = 'https://www.bing.com/search?q=%{keyword}&setlang=%{language}'

    def initialize(keyword:, language: 'en')
      @search_url = format(BING_SEARCH_URL, keyword: keyword, language: language)
    end

    def search
      uri = URI.parse(@search_url)

      response = Faraday.get(uri)

      response.body if response.status == 200
    rescue Faraday::ConnectionFailed
      raise IcRailsHueyToby::Errors::ClientServiceError
    end
  end
end
