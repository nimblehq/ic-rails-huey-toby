# frozen_string_literal: true

class SearchKeywordJob < ApplicationJob
  queue_as :scrapers

  def perform(search_result_id)
    search_result = SearchResult.find(search_result_id)
    html_code = Search::SearchService.new(
      keyword: search_result.keyword,
      search_engine: search_result.search_engine
    ).search

    return mark_as_failed(search_result) unless html_code

    mark_as_completed(search_result, html_code)
  rescue IcRailsHueyToby::Errors::SearchServiceError
    mark_as_failed(search_result)
  end

  private

  def mark_as_completed(search_result, html_code)
    search_result.update html_code: html_code, status: :completed
  end

  def mark_as_failed(search_result)
    search_result.update status: :failed
  end
end
