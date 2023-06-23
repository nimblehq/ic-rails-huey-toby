# frozen_string_literal: true

module Search
  class GoogleSearchService
    GOOGLE_SEARCH_URL = 'https://www.google.com/search?q=%{keyword}&hl=%{language}&lr=%{language}'

    def initialize(keyword:, language: 'en')
      @search_url = format(GOOGLE_SEARCH_URL, keyword: keyword, language: language)
    end

    def search
      uri = URI.parse(@search_url)

      headers = UserAgentHeaderGenerator.call
      response = Faraday.get(uri, nil, headers)

      response.body if response.status == 200
    rescue Faraday::ConnectionFailed
      raise IcRailsHueyToby::Errors::SearchServiceError
    end
  end
end
