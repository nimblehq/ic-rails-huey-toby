# frozen_string_literal: true

class ClientServiceError < StandardError; end

class SearchKeywordJob < ApplicationJob
  queue_as :default

  def perform(search_result)
    html_code = Search::SearchService.new(
      keyword: search_result.keyword,
      search_engine: search_result.search_engine
    ).search

    raise ClientServiceError unless html_code

    search_result.update html_code: html_code, status: :completed
  rescue Faraday::ConnectionFailed, ClientServiceError, NotImplementedError
    search_result.update status: :failed
  end
end
