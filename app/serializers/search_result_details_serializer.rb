# frozen_string_literal: true

class SearchResultDetailsSerializer
  include JSONAPI::Serializer

  attributes :keyword, :search_engine, :status, :html_code,
             :adwords_top_count, :adwords_total_count, :adwords_top_urls,
             :non_adwords_count, :non_adwords_urls, :total_links_count
end
