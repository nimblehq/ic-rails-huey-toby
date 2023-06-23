# frozen_string_literal: true

require 'rails_helper'

GOOGLE_ADWORDS_TOP_URLS = [
  'https://mihanoi.vn/san-pham/smart-tivi-xiaomi-a2-32-inch-chinh-hang',
  'https://hc.com.vn/ords/p--tivi-samsung-ua65au7000',
  'https://www.samsung.com/vn/tvs/uhd-4k-tv/au7000-uhd-4k-smart-tv-55-inch-ua55au7000kxxv/',
  'https://hc.com.vn/ords/p--tivi-lg-43up7550ptc'
].freeze

GOOGLE_NON_ADWORDS_URLS = [
  'https://www.dienmayxanh.com/tivi',
  'https://www.nguyenkim.com/tivi/',
  'https://dienmaycholon.vn/tivi',
  'https://cellphones.com.vn/tivi.html',
  'https://mediamart.vn/tivi',
  'https://hc.com.vn/ords/c--tivi',
  'https://tiki.vn/tivi/c5015',
  'https://pico.vn/tivi-nhom-157.html',
  'https://dienmaygiare.net/tivi/'
].freeze

RSpec.describe Parse::GoogleParseService, type: :service do
  describe '#parse' do
    context 'given the html_code is valid' do
      it 'returns parse result', vcr: 'services/search/google/valid' do
        search_service = Search::GoogleSearchService.new(keyword: 'tivi')
        html_code = search_service.search

        parse_service = described_class.new(html_code)
        parse_result = parse_service.parse

        expect(parse_result).to eq(
          {
            adwords_top_urls: GOOGLE_ADWORDS_TOP_URLS,
            adwords_top_count: 4,
            adwords_total_count: 4,
            non_adwords_urls: GOOGLE_NON_ADWORDS_URLS,
            non_adwords_count: 9,
            total_links_count: 13
          }
        )
      end
    end

    context 'given an INVALID html_code' do
      it 'raises an error' do
        expect { described_class.new(nil) }.to raise_error(IcRailsHueyToby::Errors::ParseServiceError)
      end
    end
  end
end
