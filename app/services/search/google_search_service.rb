# frozen_string_literal: true

module Search
  class GoogleSearchService
    GOOGLE_SEARCH_URL = 'https://www.google.com/search?q=%{keyword}&hl=%{language}&lr=%{language}'

    USER_AGENT_HEADER = 'User-Agent'

    X_FORWARDED_FOR_HEADER = 'X-Forwarded-For'

    def initialize(keyword, language = 'en')
      @search_url = format(GOOGLE_SEARCH_URL, keyword: keyword, language: language)
    end

    def search
      connection = create_connection(@search_url)

      response = connection.get

      response.body if response.status == 200
    rescue Faraday::ConnectionFailed
      raise IcRailsHueyToby::Errors::SearchServiceError
    end

    private

    def create_connection(search_url)
      uri = URI.parse(search_url)
      Faraday.new(url: uri, headers: create_request_header)
    end

    def create_request_header
      {
        USER_AGENT_HEADER => generate_user_agent,
        X_FORWARDED_FOR_HEADER => generate_ip_address
      }
    end

    def generate_user_agent
      Ronin::Web::UserAgents.chrome.random
    end

    def generate_ip_address
      FFaker::Internet.ip_v4_address
    end
  end
end
