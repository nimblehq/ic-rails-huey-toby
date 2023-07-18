# frozen_string_literal: true

module Api
  module V1
    class SearchResultsController < ApplicationController
      include HasPagination
      include HasDoorkeeperAuthentication

      skip_before_action :ensure_valid_client

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
        search_result_list = create_search_results_query

        pagy, paginated_results = paginated_resources_for(search_result_list)

        search_result_serializer = SearchResultsSerializer.new(paginated_results, meta: meta_from_pagy(pagy))

        render(json: search_result_serializer, status: :ok)
      end

      private

      def create_search_results_query
        SearchResultsQuery.new(
          current_user.search_results, {
            url_equals: filter_params[:url_equals],
            adwords_url_contains: filter_params[:adwords_url_contains],
            url_contains_at_least_one: filter_params[:url_contains_at_least_one],
            url_contains_at_least_two: filter_params[:url_contains_at_least_two]
          }
        ).call
      end

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

      def filter_params
        params.fetch(:filter, {}).permit(
          :url_equals,
          :adwords_url_contains,
          :url_contains_at_least_one,
          :url_contains_at_least_two
        )
      end
    end
  end
end
