# frozen_string_literal: true

module Api
  module V1
    class SearchResultsController < ApplicationController
      include Paginable
      include DoorkeeperAuthenticatable

      def create
        if upload_form.valid?
          search_results = upload_form.save

          message = I18n.t('activemodel.notices.models.search_result.create')
          search_results_serializer = SearchResultsSerializer.new(search_results, meta: { message: message })

          render(json: search_results_serializer, status: :created)
        else
          render_error(detail: upload_form.errors.full_messages, status: :unprocessable_entity)
        end
      end

      def index
        search_result_list = current_user.search_results.order(:id)
        pagy, paginated_results = paginated_resources_for(search_result_list)

        search_result_serializer = SearchResultsSerializer.new(paginated_results, meta: meta_from_pagy(pagy))

        render(json: search_result_serializer, status: :ok)
      end

      private

      def upload_form
        @upload_form ||= UploadForm.new(
          search_engine: upload_form_params[:search_engine],
          csv_file: upload_form_params[:csv_file],
          user_id: current_user.id
        )
      end

      def upload_form_params
        params.permit(:search_engine, :csv_file)
      end
    end
  end
end
