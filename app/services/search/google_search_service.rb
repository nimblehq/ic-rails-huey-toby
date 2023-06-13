# frozen_string_literal: true

module Search
  class GoogleSearchService
    attr_reader :raw_html, :adwords_top_count, :adwords_total_count, :adwords_top_urls, :non_adwords_count, :non_adwords_urls,
                :total_links_count

    GOOGLE_SEARCH_URL = 'https://www.google.com/search?q=%{keyword}&hl=%{language}&lr=%{language}'
    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36'

    def initialize(keyword, language = 'en')
      @search_url = format(GOOGLE_SEARCH_URL, keyword: keyword, language: language)
    end

    def search
      uri = URI.parse(@search_url)

      response = Faraday.get(uri, nil, 'User-Agent' => USER_AGENT)

      @raw_html = response.body if response.status == 200
    rescue Faraday::ConnectionFailed
      raise IcRailsHueyToby::Errors::SearchServiceError
    end
  end
end
