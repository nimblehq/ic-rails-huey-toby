# frozen_string_literal: true

class SearchResult < ApplicationRecord
  SEARCH_ENGINES = %w[google bing].freeze

  validates :keyword, presence: true
  validates :search_engine, presence: true, inclusion: { in: SEARCH_ENGINES }
end
