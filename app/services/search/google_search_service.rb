# frozen_string_literal: true

module Search
  class GoogleSearchService
    attr_reader :search_url

    GOOGLE_SEARCH_URL = 'https://www.google.com/search?q=%{keyword}&hl=%{language}&lr=%{language}'

    def initialize(keyword, language = 'en')
      @search_url = format(GOOGLE_SEARCH_URL, keyword: keyword, language: language)
    end
  end
end
