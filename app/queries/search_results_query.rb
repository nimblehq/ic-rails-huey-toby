# frozen_string_literal: true

CONDITION_URL_EQUALS = '? = ANY (adwords_top_urls) OR ? = ANY (non_adwords_urls)'
CONDITION_ADWORDS_URL_CONTAINS = "array_to_string(adwords_top_urls, ', ') ILIKE ?"

class SearchResultsQuery
  attr_reader :search_results, :filters

  def initialize(search_results = nil, filters = {})
    @search_results = search_results || SearchResult.all
    @filters = filters
  end

  def call
    filter_by_url_equals if filters[:url_equals].present?
    filter_adwords_url_contains if filters[:adwords_url_contains].present?

    @search_results
  end

  def filter_by_url_equals
    url = filters[:url_equals]
    @search_results = @search_results.where(CONDITION_URL_EQUALS, url, url)
  end

  def filter_adwords_url_contains
    word = filters[:adwords_url_contains]
    @search_results = @search_results.where(CONDITION_ADWORDS_URL_CONTAINS, word)
  end
end
