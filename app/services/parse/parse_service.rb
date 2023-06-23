# frozen_string_literal: true

module Parse
  class ParseService
    def self.new(search_engine:, html_code:)
      case search_engine.to_sym
      when :google
        Parse::GoogleParseService.new(html_code)
      when :bing
        Parse::BingParseService.new(html_code)
      else
        raise IcRailsHueyToby::Errors::ParseServiceError
      end
    end
  end
end
