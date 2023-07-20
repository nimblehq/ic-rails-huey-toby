# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchResultsQuery, type: :model do
  describe '#call' do
    context 'given NO filters' do
      it 'returns all search results' do
        user = Fabricate(:user)

        # Expected matches
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

        # Expected matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['www.nimblehq.co'])

        # Non-matches
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

        # Expected matches
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['www.nimblehq.co/compass'])

        # Non-matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass'])
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['www.nimblehq.co'])

        search_results_query = described_class.new(nil, { adwords_url_contains: 'compass' })

        search_results_query.call

        expect(search_results_query.search_results.count).to eq 1
      end
    end

    context 'given filter_urls_contains filter' do
      context 'given filter_match_count at least one filter' do
        it 'returns only the search results which contain the character' do
          user = Fabricate(:user)

          # Expected matches
          Fabricate(:search_result, user_id: user.id, non_adwords_urls: [], adwords_top_urls: ['www.nimblehq.co/compass'])
          Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass'], adwords_top_urls: [])

          # Non-matches
          Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co'], adwords_top_urls: [])
          Fabricate(:search_result, user_id: user.id, non_adwords_urls: [], adwords_top_urls: ['www.nimblehq.co'])

          search_results_query = described_class.new(nil, { url_contains: '/', match_count: 1 })

          search_results_query.call

          expect(search_results_query.search_results.count).to eq 2
        end
      end

      context 'given filter_match_count at least two filter' do
        it 'returns only the search results which contain the character' do
          user = Fabricate(:user)

          # Expected matches
          Fabricate(:search_result, user_id: user.id, non_adwords_urls: [], adwords_top_urls: ['www.nimblehq.co/compass/development/code-conventions'])
          Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass/development'], adwords_top_urls: [])

          # Non-matches
          Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass'], adwords_top_urls: [])
          Fabricate(:search_result, user_id: user.id, non_adwords_urls: [], adwords_top_urls: ['www.nimblehq.co'])

          search_results_query = described_class.new(nil, { url_contains: '/', match_count: 2 })

          search_results_query.call

          expect(search_results_query.search_results.count).to eq 2
        end
      end

      it 'returns empty when the urls does NOT match the character' do
        user = Fabricate(:user)

        # Expected matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: [], adwords_top_urls: ['www.nimblehq.co/compass'])
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass'], adwords_top_urls: [])

        # Non-matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co'], adwords_top_urls: [])
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: [], adwords_top_urls: ['www.nimblehq.co'])

        search_results_query = described_class.new(nil, { url_contains: '>', match_count: 1 })

        search_results_query.call

        expect(search_results_query.search_results.count).to eq 0
      end
    end
  end
end
