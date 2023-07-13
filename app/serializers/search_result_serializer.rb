# frozen_string_literal: true

class SearchResultSerializer < ApplicationSerializer
  attributes :keyword, :search_engine, :status
end
