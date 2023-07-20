# frozen_string_literal: true

class SearchResultsQuery
  attr_reader :search_results, :filters

  CONDITION_URL_EQUALS = ':url = ANY (adwords_top_urls) OR :url = ANY (non_adwords_urls)'
  CONDITION_ADWORDS_URL_CONTAINS = "array_to_string(adwords_top_urls, ', ') LIKE :word"

  def initialize(search_results = nil, filters = {})
    @search_results = search_results || SearchResult.all
    @filters = filters
  end

  def call
    @search_results = filter_by_url(filters[:url_equals])
    @search_results = filter_adwords_url_contains(filters[:adwords_url_contains])
    @search_results = filter_urls_contains_at_least(filters[:url_contains], filters[:match_count])

    @search_results.order(:id)
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

  def filter_urls_contains_at_least(word, match_count = 1)
    if word.present?
      search_result_ids = @search_results.select do |search_result|
        urls = search_result.adwords_top_urls + search_result.non_adwords_urls

        urls&.any? { |url| url.scan(word).count >= match_count.to_i }
      end.pluck(:id)

      @search_results.where(id: search_result_ids)
    else
      @search_results
    end
  end
end
