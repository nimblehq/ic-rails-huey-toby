# frozen_string_literal: true

module Api
  module V1
    class ExportsController < ApplicationController
      include DoorkeeperAuthenticatable

      def index
        search_result = SearchResult.find_by(id: params[:search_result_id])

        unless search_result
          raise IcRailsHueyToby::Errors::RecordNotFound,
                I18n.t('activemodel.errors.models.search_result.not_found')
        end

        grover = Grover.new(search_result.html_code).to_pdf

        send_data(grover, filename: 'export.pdf', type: 'application/pdf', disposition: 'attachment')
      end
    end
  end
end
