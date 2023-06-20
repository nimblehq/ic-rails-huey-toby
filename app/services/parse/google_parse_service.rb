# frozen_string_literal: true

module Parse
  class GoogleParseService
    SELECTORS = {
      adwords_top: 'div.pla-unit-container a.pla-unit-title-link',
      adwords_body: 'div.data-text-ad div.v5yQqb',
      non_adwords: 'div#search div.yuRUbf a[data-ved]',
      href: 'href'
    }.freeze

    def initialize(html_code)
      @html_code = html_code
      raise IcRailsHueyToby::Errors::ParseServiceError unless html_code
    end

    def parse
      parse_html
    end

    private

    attr_reader :html_code

    def parse_html
      doc = Nokogiri::HTML(html_code)

      adwords_result = parse_adwords(doc)
      non_adwords_result = parse_non_adwords(doc)
      total_links_count = parse_total_links_count(adwords_result, non_adwords_result)

      adwords_result.merge(non_adwords_result, { total_links_count: total_links_count })
    end

    def parse_top_adwords(doc)
      top_ads_container = doc.css(SELECTORS[:adwords_top])

      parse_url(top_ads_container)
    end

    def parse_body_adwords(doc)
      body_ads_container = doc.css(SELECTORS[:adwords_body])

      parse_url(body_ads_container)
    end

    def parse_adwords(doc)
      adwords_top_urls = parse_top_adwords(doc)
      adwords_body_urls = parse_body_adwords(doc)

      adwords_top_count = adwords_top_urls.count
      adwords_body_count = adwords_body_urls.count
      adwords_total_count = adwords_top_count + adwords_body_count

      {
        adwords_top_urls: adwords_top_urls,
        adwords_top_count: adwords_top_count,
        adwords_total_count: adwords_total_count
      }
    end

    def parse_non_adwords(doc)
      non_adwords_container = doc.css(SELECTORS[:non_adwords])

      non_adwords_urls = parse_url(non_adwords_container)
      non_adwords_count = non_adwords_urls.count

      {
        non_adwords_urls: non_adwords_urls,
        non_adwords_count: non_adwords_count
      }
    end

    def parse_total_links_count(adwords_result, non_adwords_result)
      adwords_result[:adwords_total_count] + non_adwords_result[:non_adwords_count]
    end

    def parse_url(container)
      container.map do |element|
        element[SELECTORS[:href]]
      end
    end
  end
end
