# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchKeywordJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    context 'given a valid request' do
      it 'updates the keyword status as completed', vcr: 'services/search/google/valid' do
        search_result = SearchResult.create(keyword: 'tivi', search_engine: 'google')

        expect(search_result.status).to eq('in_progress')

        expect { described_class.perform_now(search_result.id) }
          .to change { search_result.reload.status }
          .to('completed').and change { search_result.html_code }
          .to(include('<title>tivi - Google Search</title>'))
      end

      it 'updates the adwords_top_urls with the parsed content from the search page', vcr: 'services/search/google/valid' do
        search_result = SearchResult.create(keyword: 'tivi', search_engine: 'google')

        expect { described_class.perform_now(search_result.id) }
          .to change { search_result.reload.adwords_top_urls }
          .to([
                'https://mihanoi.vn/san-pham/smart-tivi-xiaomi-a2-32-inch-chinh-hang',
                'https://hc.com.vn/ords/p--tivi-samsung-ua65au7000',
                'https://www.samsung.com/vn/tvs/uhd-4k-tv/au7000-uhd-4k-smart-tv-55-inch-ua55au7000kxxv/',
                'https://hc.com.vn/ords/p--tivi-lg-43up7550ptc'
              ])
      end

      it 'updates the adwords_top_count with the parsed content from the search page', vcr: 'services/search/google/valid' do
        search_result = SearchResult.create(keyword: 'tivi', search_engine: 'google')

        expect { described_class.perform_now(search_result.id) }
          .to change { search_result.reload.adwords_top_count }
          .to(4)
      end

      it 'updates the adwords_total_count with the parsed content from the search page', vcr: 'services/search/google/valid' do
        search_result = SearchResult.create(keyword: 'tivi', search_engine: 'google')

        expect { described_class.perform_now(search_result.id) }
          .to change { search_result.reload.adwords_total_count }
          .to(4)
      end

      it 'updates the non_adwords_urls with the parsed content from the search page', vcr: 'services/search/google/valid' do
        search_result = SearchResult.create(keyword: 'tivi', search_engine: 'google')

        expect { described_class.perform_now(search_result.id) }
          .to change { search_result.reload.non_adwords_urls }
          .to([
                'https://www.dienmayxanh.com/tivi',
                'https://www.nguyenkim.com/tivi/',
                'https://dienmaycholon.vn/tivi',
                'https://cellphones.com.vn/tivi.html',
                'https://mediamart.vn/tivi',
                'https://hc.com.vn/ords/c--tivi',
                'https://tiki.vn/tivi/c5015',
                'https://pico.vn/tivi-nhom-157.html',
                'https://dienmaygiare.net/tivi/'
              ])
      end

      it 'updates the non_adwords_count with the parsed content from the search page', vcr: 'services/search/google/valid' do
        search_result = SearchResult.create(keyword: 'tivi', search_engine: 'google')

        expect { described_class.perform_now(search_result.id) }
          .to change { search_result.reload.non_adwords_count }
          .to(9)
      end

      it 'updates the total_links_count with the parsed content from the search page', vcr: 'services/search/google/valid' do
        search_result = SearchResult.create(keyword: 'tivi', search_engine: 'google')

        expect { described_class.perform_now(search_result.id) }
          .to change { search_result.reload.total_links_count }
          .to(13)
      end
    end

    context 'given NO html code is returned' do
      it 'updates the keyword status as failed' do
        search_result = SearchResult.create(keyword: 'keyword', search_engine: 'google')
        search_service = Search::SearchService.new(keyword: 'keyword', search_engine: 'google')
        allow(Search::SearchService).to receive(:new).and_return(search_service)
        allow(search_service).to receive(:search).and_return(nil)

        expect { described_class.perform_now(search_result.id) }.to change { search_result.reload.status }.to('failed')
      end
    end

    context 'given SearchServiceError is raised' do
      it 'updates the keyword status as failed' do
        search_result = SearchResult.create(keyword: 'keyword', search_engine: 'google')
        search_service = Search::SearchService.new(keyword: 'keyword', search_engine: 'google')
        allow(Search::SearchService).to receive(:new).and_return(search_service)
        allow(search_service).to receive(:search).and_raise(IcRailsHueyToby::Errors::SearchServiceError)

        expect { described_class.perform_now(search_result.id) }.to change { search_result.reload.status }.to('failed')
      end
    end
  end
end
