# frozen_string_literal: true

module Api
  module V1
    class SearchResultController < ApplicationController
      def index
        @search = SearchResult.new(search_params)
        # TODO: Temporary returns the response from Google Search Service for testing purpose
        @service = Search::Google::SearchService.new(@search.keyword)
        @result = @service.search

        # FIXME: Temporary workaround to fix the encoding issue
        # PG::CharacterNotInRepertoire: ERROR:  invalid byte sequence for encoding "UTF8":
        @search.html_code = @result.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
        @search.status = :completed
        @search.search_engine = 'google'
        @search.save

        render json: @search
      end

      private

      def search_params
        params.permit(:keyword)
      end
    end
  end
end
