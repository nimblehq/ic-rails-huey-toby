# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Parse::GoogleParseService, type: :service do
  describe '#parse' do
    context 'given the html_code is valid' do
      it 'returns parse result', vcr: 'services/search/google/valid' do
        search_service = Search::GoogleSearchService.new(keyword: 'tivi')
        html_code = search_service.search

        parse_service = described_class.new(html_code)
        parse_result = parse_service.parse

        expect(parse_result[:adwords_top_urls]).to eq(
          [
            'https://mihanoi.vn/san-pham/smart-tivi-xiaomi-a2-32-inch-chinh-hang',
            'https://hc.com.vn/ords/p--tivi-samsung-ua65au7000',
            'https://www.samsung.com/vn/tvs/uhd-4k-tv/au7000-uhd-4k-smart-tv-55-inch-ua55au7000kxxv/',
            'https://hc.com.vn/ords/p--tivi-lg-43up7550ptc'
          ]
        )
        expect(parse_result[:adwords_top_count]).to eq(4)
        expect(parse_result[:adwords_total_count]).to eq(4)
        expect(parse_result[:non_adwords_urls]).to eq(
          [
            'https://www.dienmayxanh.com/tivi',
            'https://www.nguyenkim.com/tivi/',
            'https://dienmaycholon.vn/tivi',
            'https://cellphones.com.vn/tivi.html',
            'https://mediamart.vn/tivi',
            'https://hc.com.vn/ords/c--tivi',
            'https://tiki.vn/tivi/c5015',
            'https://pico.vn/tivi-nhom-157.html',
            'https://dienmaygiare.net/tivi/'
          ]
        )
        expect(parse_result[:non_adwords_count]).to eq(9)
        expect(parse_result[:total_links_count]).to eq(13)
      end
    end

    context 'given an INVALID html_code' do
      it 'raises an error' do
        expect { described_class.new(nil) }.to raise_error(IcRailsHueyToby::Errors::ParseServiceError)
      end
    end
  end
end
