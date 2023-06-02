# frozen_string_literal: true

class SearchResult < ApplicationRecord
  enum search_engines: { google: 0, bing: 1 }

  validates :keyword, presence: true
  validates :search_engine, presence: true
end
