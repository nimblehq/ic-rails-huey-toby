# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::SearchService, type: :service do
  describe '#initialize' do
    context 'given the search engine is google' do
      it 'returns instance of GoogleSearchService' do
        search_service = described_class.new(search_engine: 'google', keyword: 'ruby')
        expect(search_service).to be_a(Search::GoogleSearchService)
      end
    end

    context 'given the search engine is INVALID' do
      it 'raises an error' do
        expect { described_class.new(search_engine: 'yahoo', keyword: 'ruby') }.to raise_error(NotImplementedError)
      end
    end
  end

  describe '#search' do
    context 'given the search engine is valid' do
      context 'given the search result is valid' do
        it 'returns search page body', vcr: 'services/search/google/valid' do
          search_service = described_class.new(search_engine: 'google', keyword: 'ruby')
          search_result = search_service.search

          expect(search_result).to include('<title>ruby - Google Search</title>')
        end
      end

      context 'given an INVALID search result' do
        it 'returns nil' do
          stub_request(:any, /www\.google\.com/).to_return(status: 404)

          search_service = described_class.new(search_engine: 'google', keyword: 'ruby')
          search_result = search_service.search

          expect(search_result).to be_nil
        end
      end
    end
  end
end
