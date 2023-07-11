# frozen_string_literal: true

class SearchResult < ApplicationRecord
  enum search_engine: { google: 'google', bing: 'bing' }
  enum status: { in_progress: 'in_progress', completed: 'completed', failed: 'failed' }

  belongs_to :user

  validates :keyword, :search_engine, :status, presence: true
  validates :search_engine, inclusion: { in: search_engines.keys }
  validates :status, inclusion: { in: statuses.keys }
end
