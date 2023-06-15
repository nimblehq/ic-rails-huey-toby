# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::SearchService, type: :service do
  describe '.new' do
    context 'given the search engine is google' do
      it 'returns instance of GoogleSearchService' do
        search_service = described_class.new(search_engine: 'google', keyword: 'ruby')

        expect(search_service).to be_a(Search::GoogleSearchService)
      end
    end

    context 'given the search engine is bing' do
      it 'returns instance of BingSearchService' do
        search_service = described_class.new(search_engine: 'bing', keyword: 'ruby')

        expect(search_service).to be_a(Search::BingSearchService)
      end
    end

    context 'given the search engine is INVALID' do
      it 'raises an error' do
        expect { described_class.new(search_engine: 'yahoo', keyword: 'ruby') }.to raise_error(IcRailsHueyToby::Errors::SearchServiceError)
      end
    end
  end
end
