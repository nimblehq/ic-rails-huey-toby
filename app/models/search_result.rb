# frozen_string_literal: true

class SearchResult < ApplicationRecord
  enum search_engine: { google: 'google', bing: 'bing' }
  enum status: { in_progress: 'in_progress', completed: 'completed', failed: 'failed' }

  validates :keyword, presence: true
  validates :search_engine, presence: true
  validates :search_engine, inclusion: { in: search_engines.keys }
  validates :status, presence: true
  validates :status, inclusion: { in: statuses.keys }
end
