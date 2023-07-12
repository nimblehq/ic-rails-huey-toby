# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchResultsQuery, type: :model do
  describe '#call' do
    context 'given NO filters' do
      it 'returns all search results' do
        user = Fabricate(:user)
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['www.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['www.nimblehq.co/compass'])
        search_results_query = described_class.new

        search_results_query.call

        expect(search_results_query.search_results.count).to eq 4
      end
    end

    context 'given url_equals filter' do
      it 'returns only the search results that are equal to the url' do
        user = Fabricate(:user)
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['www.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['www.nimblehq.co/compass'])
        search_results_query = described_class.new(nil, { url_equals: 'www.nimblehq.co' })

        search_results_query.call

        expect(search_results_query.search_results.count).to eq 2
      end
    end

    context 'given adwords_url_contains filter' do
      it 'returns only the search results which contain the word' do
        user = Fabricate(:user)
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['www.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['www.nimblehq.co/compass'])
        search_results_query = described_class.new(nil, { adwords_url_contains: 'compass' })

        search_results_query.call

        expect(search_results_query.search_results.count).to eq 1
      end
    end
  end
end
