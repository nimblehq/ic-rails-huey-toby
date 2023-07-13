# frozen_string_literal: true

CONDITION_URL_EQUALS = '? = ANY (adwords_top_urls) OR ? = ANY (non_adwords_urls)'

class SearchResultsQuery
  attr_reader :search_results, :filters, :sorts

  def initialize(search_results = nil, filters = {})
    @search_results = search_results || SearchResult.all
    @filters = filters
  end

  def call
    url = filters[:url_equals]

    @search_results = @search_results.where(CONDITION_URL_EQUALS, url, url) if url.present?

    @search_results
  end
end
