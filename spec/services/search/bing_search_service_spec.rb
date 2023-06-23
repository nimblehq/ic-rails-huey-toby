# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::BingSearchService, type: :service do
  describe '#search' do
    context 'given the search result is valid' do
      it 'returns search page body', vcr: 'services/search/bing/valid' do
        search_service = described_class.new(keyword: 'watch')
        search_result = search_service.search

        expect(search_result).to include('<title>watch - Search</title>')
      end
    end

    context 'given an INVALID search result' do
      it 'returns nil' do
        stub_request(:any, /www\.bing\.com/).to_return(status: 404)

        search_service = described_class.new(keyword: 'ruby')
        search_result = search_service.search

        expect(search_result).to be_nil
      end
    end
  end
end
