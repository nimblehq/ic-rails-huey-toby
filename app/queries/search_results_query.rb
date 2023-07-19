# frozen_string_literal: true

class SearchResultsQuery
  attr_reader :search_results, :filters, :sorts

  CONDITION_URL_EQUALS = ':url = ANY (adwords_top_urls) OR :url = ANY (non_adwords_urls)'

  def initialize(search_results = nil, filters = {})
    @search_results = search_results || SearchResult.all
    @filters = filters
  end

  def call
    @search_results = filter_by_url(filters[:url_equals])

    @search_results
  end

  def filter_by_url(url)
    if url.present?
      @search_results.where(CONDITION_URL_EQUALS, url: url)
    else
      @search_results
    end
  end
end
