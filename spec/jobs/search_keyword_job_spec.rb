# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchKeywordJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    context 'given a valid request' do
      it 'updates the keyword status as completed', vcr: 'services/search/google/valid' do
        search_result = SearchResult.create(keyword: 'ruby', search_engine: 'google')

        expect(search_result.status).to eq('in_progress')

        expect { described_class.perform_now(search_result.id) }
          .to change { search_result.reload.status }
          .to('completed').and change { search_result.html_code }
          .to(include('<title>ruby - Google Search</title>'))
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
