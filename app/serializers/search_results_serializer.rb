# frozen_string_literal: true

class SearchResultsSerializer < ApplicationSerializer
  attributes :keyword, :search_engine, :status
end
