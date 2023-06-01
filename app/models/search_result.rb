# frozen_string_literal: true

class SearchResult < ApplicationRecord
  SEARCH_ENGINES = %w[Google Bing].freeze

  validates :keyword, presence: true
  validates :search_engine, presence: true, inclusion: { in: SEARCH_ENGINES }
end
