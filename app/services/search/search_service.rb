# frozen_string_literal: true

module Search
  class SearchService
    def self.new(search_engine:, keyword:, language: 'en')
      case search_engine.to_sym
      when :google
        Search::GoogleSearchService.new(keyword, language)
      else
        raise NotImplementedError
      end
    end
  end
end
