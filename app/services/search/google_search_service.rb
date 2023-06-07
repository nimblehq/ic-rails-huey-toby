# frozen_string_literal: true

module Search
  class GoogleSearchService
    GOOGLE_SEARCH_URL = 'https://www.google.com/search?q=%{keyword}&hl=%{language}&lr=%{language}'

    def initialize(keyword, language = 'en')
      @search_url = format(GOOGLE_SEARCH_URL, keyword: keyword, language: language)
    end

    def search
      uri = URI.parse(@search_url)

      response = Faraday.get(uri)

      # TODO: Handle error in background job
      # https://github.com/nimblehq/ic-rails-huey-toby/issues/19
      response.body if response.status == 200
    end
  end
end
