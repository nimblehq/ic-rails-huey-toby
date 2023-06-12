# frozen_string_literal: true

class SearchKeywordJob < ApplicationJob
  queue_as :scrapers

  def perform(search_result_id)
    search_result = SearchResult.find(search_result_id)
    html_code = Search::SearchService.new(
      keyword: search_result.keyword,
      search_engine: search_result.search_engine
    ).search

    raise IcRailsHueyToby::Errors::ClientServiceError unless html_code

    search_result.update html_code: html_code, status: :completed
  rescue Faraday::ConnectionFailed, IcRailsHueyToby::Errors::ClientServiceError, NotImplementedError
    search_result.update status: :failed
  end
end
