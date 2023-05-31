# frozen_string_literal: true

module Search
  class BaseService
    attr_reader :keyword, :language

    def initialize(keyword, language = 'en')
      @keyword = keyword
      @language = language
    end
  end
end
