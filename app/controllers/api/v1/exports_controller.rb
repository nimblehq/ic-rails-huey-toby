# frozen_string_literal: true

module Api
  module V1
    class ExportsController < ApplicationController
      include HasDoorkeeperAuthentication

      skip_before_action :ensure_valid_client

      def show
        search_result = SearchResult.find(params[:search_result_id])

        grover = Grover.new(search_result.html_code).to_pdf

        send_data(grover, filename: 'export.pdf', type: 'application/pdf', disposition: 'attachment')
      end
    end
  end
end
