# frozen_string_literal: true

module Api
  module V1
    class SearchResultsController < ApplicationController
      include HasPagination
      include HasDoorkeeperAuthentication

      skip_before_action :ensure_valid_client

      def create
        if upload_form.valid?
          search_result_list = upload_form.save

          upload_meta = upload_meta(search_result_list: search_result_list)
          search_result_serializer = SearchResultListSerializer.new(search_result_list, upload_meta)

          render(json: search_result_serializer, status: :created)
        else
          render_error(detail: upload_form.errors.full_messages, status: :unprocessable_entity)
        end
      end

      def index
        search_result_list = create_search_results_query

        pagy, paginated_result_list = paginated_resources_for(search_result_list)

        search_result_list_serializer = SearchResultListSerializer.new(paginated_result_list, meta: meta_from_pagy(pagy))

        render(json: search_result_list_serializer, status: :ok)
      end

      def show
        search_result = SearchResult.find(params[:id])

        search_result_serializer = SearchResultSerializer.new(search_result)

        render(json: search_result_serializer, status: :ok)
      end

      private

      def create_search_results_query
        SearchResultsQuery.new(
          current_user.search_results, {
            url_equals: filter_params[:url_equals],
            adwords_url_contains: filter_params[:adwords_url_contains],
            url_contains: filter_params[:url_contains],
            match_count: filter_params[:match_count]
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
        params.fetch(:filter, {}).permit(:url_equals, :adwords_url_contains, :url_contains,
                                         :match_count)
      end

      def upload_meta(search_result_list:)
        {
          meta: {
            message: I18n.t('activemodel.notices.models.search_result.create'),
            total: search_result_list.size
          }
        }
      end
    end
  end
end
