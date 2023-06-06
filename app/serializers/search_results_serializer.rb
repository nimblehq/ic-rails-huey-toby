# frozen_string_literal: true

class SearchResultsSerializer
  include JSONAPI::Serializer

  attributes :keyword, :search_engine
end
