# frozen_string_literal: true

module Search
  class GoogleSearchService
    GOOGLE_SEARCH_URL = 'https://www.google.com/search?q=%{keyword}&hl=%{language}&lr=%{language}'

    USER_AGENT_HEADER = 'User-Agent'

    def initialize(keyword, language = 'en')
      @search_url = format(GOOGLE_SEARCH_URL, keyword: keyword, language: language)
    end

    def search
      uri = URI.parse(@search_url)

      response = Faraday.get(uri, nil, USER_AGENT_HEADER => generate_user_agent)

      response.body if response.status == 200
    rescue Faraday::ConnectionFailed
      raise IcRailsHueyToby::Errors::SearchServiceError
    end

    private

    def generate_user_agent
      Ronin::Web::UserAgents.chrome.random
    end
  end
end
