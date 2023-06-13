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

    private

    def parse_html
      doc = Nokogiri::HTML(@raw_html)
      parse_adwords(doc)
      parse_non_adwords(doc)
    end

    def parse_adwords(doc)
      parse_top_adwords(doc)
      parse_normal_adwords(doc)
    end

    def parse_top_adwords(doc)
      top_ads_container = doc.css('div.pla-unit-container')

      @adwords_top_urls = []
      top_ads_container.each do |adwords_top|
        @adwords_top_urls << adwords_top.css('a[data-impdclcc]').first['href']
      end

      @adwords_top_count = adwords_top_urls.size
    end

    def parse_normal_adwords(doc)
      normal_adwords_count = doc.css('div[data-text-ad]').count

      @adwords_total_count = @adwords_top_count + normal_adwords_count
    end

    def parse_non_adwords(doc)
      @non_adwords_urls = []
      doc.css('#search').css('div.yuRUbf').each do |non_adwords|
        @non_adwords_urls << non_adwords.css('a').first['href']
      end
    end
  end
end
