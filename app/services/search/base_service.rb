# frozen_string_literal: true

module Search
  class BaseService
    def initialize(search_url)
      @search_url = search_url
    end

    def call
      uri = URI.parse(search_url)

      response = Net::HTTP.get_response(uri)

      response.body if response.is_a?(Net::HTTPSuccess)
    end

    private

    attr_reader :search_url
  end
end
