# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchResultsQuery, type: :model do
  describe '#call' do
    context 'given NO filters' do
      it 'returns all search results' do
        user = Fabricate(:user)

        # Expected matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['wwww.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['wwww.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['wwww.nimblehq.co/compass'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['wwww.nimblehq.co/compass'])

        search_results_query = described_class.new

        search_results_query.call

        expect(search_results_query.search_results.count).to eq 4
      end
    end

    context 'given url_equals filter' do
      it 'returns only the search results that are equal to the url' do
        user = Fabricate(:user)

        # Expected matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['wwww.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['wwww.nimblehq.co'])

        # Non-matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['wwww.nimblehq.co/compass'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['wwww.nimblehq.co/compass'])

        search_results_query = described_class.new(nil, { url_equals: 'wwww.nimblehq.co' })

        search_results_query.call

        expect(search_results_query.search_results.count).to eq 2
      end
    end
  end
end
