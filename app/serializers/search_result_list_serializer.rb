# frozen_string_literal: true

class SearchResultListSerializer < ApplicationSerializer
  attributes :keyword, :search_engine, :status
end
