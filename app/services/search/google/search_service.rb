# frozen_string_literal: true

module Search
  module Google
    class SearchService < Search::BaseService
      def initialize(keyword, language = 'en')
        search_url = "https://www.google.com/search?q=#{keyword}&hl=#{language}&lr=#{language}"
        super(search_url)
      end
    end
  end
end
