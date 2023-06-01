# frozen_string_literal: true

class SearchResult < ApplicationRecord
  enum search_engine: { google: 'google', bing: 'bing' }
  enum status: { processing: 0, completed: 1 }

  validates :keyword, presence: true
  validates :search_engine, presence: true
  validates :search_engine, inclusion: { in: search_engines.keys }
end
