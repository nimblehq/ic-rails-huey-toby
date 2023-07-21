# frozen_string_literal: true

class SearchResultListSerializer < ApplicationSerializer
  attributes :keyword, :search_engine, :status, :non_adwords_urls, :adwords_top_urls
end
