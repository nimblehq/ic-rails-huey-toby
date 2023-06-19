# frozen_string_literal: true

class SearchKeywordJob < ApplicationJob
  queue_as :scrapers

  def perform(search_result_id)
    search_result = SearchResult.find(search_result_id)
    html_code = search(search_result.keyword, search_result.search_engine)
    result = parse(search_result.search_engine, html_code)

    return mark_as_failed(search_result) unless html_code

    mark_as_completed(search_result, html_code, result)
  rescue IcRailsHueyToby::Errors::SearchServiceError
    mark_as_failed(search_result)
  end

  private

  def search(keyword, search_engine)
    Search::SearchService.new(
      keyword: keyword,
      search_engine: search_engine
    ).search
  end

  def parse(search_engine, html_code)
    Parse::ParseService.new(
      search_engine: search_engine,
      html_code: html_code
    ).parse
  end

  def mark_as_completed(search_result, html_code, result)
    search_result.update html_code: html_code, adwords_top_urls: result[:adwords_top_urls],
                         adwords_top_count: result[:adwords_top_count], adwords_total_count: result[:adwords_total_count],
                         non_adwords_urls: result[:non_adwords_urls], non_adwords_count: result[:non_adwords_count],
                         total_links_count: result[:total_links_count], status: :completed
  end

  def mark_as_failed(search_result)
    search_result.update status: :failed
  end
end
