# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::Google::SearchService, type: :service do
  describe '#call' do
    context 'given the search result is valid' do
      it 'returns search page body', vcr: 'services/search/google/valid' do
        search_result = described_class.new('ruby').call

        expect(search_result).to include('<title>ruby - Google Search</title>')
      end
    end

    context 'given an INVALID search result' do
      it 'returns nil' do
        stub_request(:any, /www\.google\.com/).to_return(status: 404, body: '', headers: {})

        search_result = described_class.new('ruby').call

        expect(search_result).to be_nil
      end
    end
  end
end
