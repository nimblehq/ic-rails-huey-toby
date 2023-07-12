# frozen_string_literal: true

class SearchResultsSerializer
  include JSONAPI::Serializer

  attributes :keyword, :search_engine, :status, :adwords_top_urls, :non_adwords_urls
end
