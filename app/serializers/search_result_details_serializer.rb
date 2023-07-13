# frozen_string_literal: true

class SearchResultDetailsSerializer < SearchResultSerializer
  attributes :html_code, :adwords_top_count, :adwords_total_count,
             :adwords_top_urls, :non_adwords_count, :non_adwords_urls,
             :total_links_count
end
