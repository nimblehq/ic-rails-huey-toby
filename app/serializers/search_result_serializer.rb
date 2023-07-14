# frozen_string_literal: true

class SearchResultSerializer < SearchResultListSerializer
  attributes :html_code, :adwords_top_count, :status, :adwords_total_count,
             :adwords_top_urls, :non_adwords_count, :non_adwords_urls,
             :total_links_count
end
