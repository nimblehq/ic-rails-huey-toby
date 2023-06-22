# frozen_string_literal: true

module Parse
  class BingParseService
    SELECTORS = {
      adwords_top: 'div.b_imagePair.square_xb div.inner a',
      adwords_body: 'div.b_adurl a',
      non_adwords: 'li.b_algo h2 a, div.pagereco_TTitle a',
      href: 'href'
    }.freeze

    def initialize(html_code)
      raise IcRailsHueyToby::Errors::ParseServiceError unless html_code

      @html_code = html_code
    end

    def parse
      doc = Nokogiri::HTML(html_code)

      adword_list = parse_adword_list(doc)
      non_adword_list = parse_non_adword_list(doc)
      total_links_count = parse_total_links_count(adword_list, non_adword_list)

      Hash.new.merge(adword_list, non_adword_list, total_links_count) # rubocop:disable Style/EmptyLiteral
    end

    private

    attr_reader :html_code

    def parse_adword_list(doc)
      adwords_top_urls = doc.css(SELECTORS[:adwords_top]).map { |element| element[SELECTORS[:href]] }
      adwords_body_urls = doc.css(SELECTORS[:adwords_body]).map { |element| element[SELECTORS[:href]] }

      adwords_top_count = adwords_top_urls.count
      adwords_body_count = adwords_body_urls.count
      adwords_total_count = adwords_top_count + adwords_body_count

      {
        adwords_top_urls: adwords_top_urls,
        adwords_top_count: adwords_top_count,
        adwords_total_count: adwords_total_count
      }
    end

    def parse_non_adword_list(doc)
      non_adwords_urls = doc.css(SELECTORS[:non_adwords]).map { |element| element[SELECTORS[:href]] }

      non_adwords_count = non_adwords_urls.count

      {
        non_adwords_urls: non_adwords_urls,
        non_adwords_count: non_adwords_count
      }
    end

    def parse_total_links_count(adword_list, non_adword_list)
      total_links_count = adword_list[:adwords_total_count] + non_adword_list[:non_adwords_count]

      { total_links_count: total_links_count }
    end
  end
end
