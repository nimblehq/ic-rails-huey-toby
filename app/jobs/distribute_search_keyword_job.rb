# frozen_string_literal: true

class DistributeSearchKeywordJob < ApplicationJob
  queue_as :scrapers

  def perform(search_result_ids)
    search_result_ids.each_with_index do |search_result_id, index|
      SearchKeywordJob.set(wait: index * 5).perform_later(search_result_id)
    end
  end
end
