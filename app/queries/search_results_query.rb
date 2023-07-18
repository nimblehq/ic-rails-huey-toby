# frozen_string_literal: true

CONDITION_URL_EQUALS = ':url = ANY (adwords_top_urls) OR :url = ANY (non_adwords_urls)'
CONDITION_ADWORDS_URL_CONTAINS = "array_to_string(adwords_top_urls, ', ') LIKE :word"

class SearchResultsQuery
  attr_reader :search_results, :filters

  def initialize(search_results = nil, filters = {})
    @search_results = search_results || SearchResult.all
    @filters = filters
  end

  def call
    @search_results = filter_by_url(filters[:url_equals])
    @search_results = filter_adwords_url_contains(filters[:adwords_url_contains])
    @search_results = filter_urls_contains_at_least(filters[:url_contains_at_least_one], 1)
    @search_results = filter_urls_contains_at_least(filters[:url_contains_at_least_two], 2)

    @search_results
  end

  def filter_by_url(url)
    if url.present?
      @search_results.where(CONDITION_URL_EQUALS, url: url)
    else
      @search_results
    end
  end

  def filter_adwords_url_contains(word)
    if word.present?
      @search_results.where(CONDITION_ADWORDS_URL_CONTAINS, word: "%#{word}%")
    else
      @search_results
    end
  end

  def filter_urls_contains_at_least(character, count = 1)
    if character.present?
      filter_ids = @search_results.select do |search_result|
        search_result.adwords_top_urls.any? { |url| url.count(character) >= count } ||
          search_result.non_adwords_urls.any? { |url| url.count(character) >= count }
      end.pluck(:id)

      SearchResult.where(id: filter_ids)
    else
      @search_results
    end
  end
end
