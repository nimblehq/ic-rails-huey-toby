# frozen_string_literal: true

module Search
  class SearchService
    def self.new(search_engine:, keyword:, language: 'en')
      case search_engine.to_sym
      when :google
        Search::GoogleSearchService.new(keyword: keyword, language: language)
      when :bing
        Search::BingSearchService.new(keyword: keyword, language: language)
      else
        raise IcRailsHueyToby::Errors::SearchServiceError
      end
    end
  end
end
