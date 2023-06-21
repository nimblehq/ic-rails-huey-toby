# frozen_string_literal: true

class SearchKeywordJob < ApplicationJob
  queue_as :scrapers

  def perform(search_result_id)
    search_result = SearchResult.find(search_result_id)
    html_code = search(search_result.keyword, search_result.search_engine)

    parse_result = parse(search_result.search_engine, html_code)

    set_parse_result(search_result, html_code, parse_result)
  rescue IcRailsHueyToby::Errors::SearchServiceError, IcRailsHueyToby::Errors::ParseServiceError
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

  def set_parse_result(search_result, html_code, parse_result)
    search_result.update parse_result.merge({ html_code: html_code })
    mark_as_completed(search_result)
  end

  def mark_as_completed(search_result)
    search_result.update status: :completed
  end

  def mark_as_failed(search_result)
    search_result.update status: :failed
  end
end
