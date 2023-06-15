# frozen_string_literal: true

require 'user_agent_randomizer'

module Search
  class GoogleSearchService
    GOOGLE_SEARCH_URL = 'https://www.google.com/search?q=%{keyword}&hl=%{language}&lr=%{language}'

    USER_AGENT_HEADER = 'User-Agent'
    USER_AGENT_TYPE = 'desktop_browser'

    KEY_DIV_TOP_ADWORDS_CONTAINER = 'div.pla-unit-container'
    KEY_DIV_NORMAL_ADWORDS_CONTAINER = 'div.v5yQqb'
    KEY_DIV_NON_ADWORDS_CONTAINER = 'div.yuRUbf'

    KEY_A_TAG = 'a'
    KEY_A_TAG_ADWORDS_TOP_CLASS = 'a[data-impdclcc]'

    KEY_HREF_ATTRIBUTE = 'href'

    def initialize(keyword, language = 'en')
      @search_url = format(GOOGLE_SEARCH_URL, keyword: keyword, language: language)
    end

    def search
      uri = URI.parse(@search_url)

      response = Faraday.get(uri, nil, USER_AGENT_HEADER => generate_user_agent)

      @html_code = response.body if response.status == 200

      parse_html(@html_code)
    rescue Faraday::ConnectionFailed
      raise IcRailsHueyToby::Errors::SearchServiceError
    end

    private

    def generate_user_agent
      UserAgentRandomizer::UserAgent.fetch(type: USER_AGENT_TYPE).string
    end

    # rubocop:disable Metrics/MethodLength
    def parse_html(html_code)
      doc = Nokogiri::HTML(html_code)

      adwords_top_urls = parse_top_adwords(doc)
      adwords_normal_urls = parse_normal_adwords(doc)
      non_adwords_urls = parse_non_adwords(doc)

      adwords_top_count = adwords_top_urls.size
      adwords_normal_count = adwords_normal_urls.size
      adwords_total_count = adwords_top_count + adwords_normal_count
      non_adwords_count = non_adwords_urls.size
      total_links_count = adwords_top_count + adwords_normal_count + non_adwords_count

      SearchResult.new(
        adwords_top_urls: adwords_top_urls,
        adwords_top_count: adwords_top_count,
        non_adwords_urls: non_adwords_urls,
        non_adwords_count: non_adwords_count,
        adwords_total_count: adwords_total_count,
        total_links_count: total_links_count,
        # html_code: html_code,
        search_engine: 'google',
        keyword: @keyword
      )
    end
    # rubocop:enable Metrics/MethodLength

    def parse_top_adwords(doc)
      top_ads_container = doc.css(KEY_DIV_TOP_ADWORDS_CONTAINER)

      adwords_top_urls = []
      top_ads_container.each do |adwords_top|
        adwords_top_urls << adwords_top.css(KEY_A_TAG_ADWORDS_TOP_CLASS).first[KEY_HREF_ATTRIBUTE]
      end

      adwords_top_urls
    end

    def parse_normal_adwords(doc)
      normal_ads_container = doc.css(KEY_DIV_NORMAL_ADWORDS_CONTAINER)

      adwords_normal_urls = []
      normal_ads_container.each do |adwords_normal|
        adwords_normal_urls << adwords_normal.css(KEY_A_TAG).first[KEY_HREF_ATTRIBUTE]
      end

      adwords_normal_urls
    end

    def parse_non_adwords(doc)
      non_adwords_urls = []

      doc.css(KEY_DIV_NON_ADWORDS_CONTAINER).each do |non_adwords|
        non_adwords_urls << non_adwords.css(KEY_A_TAG).first[KEY_HREF_ATTRIBUTE]
      end

      non_adwords_urls
    end
  end
end
