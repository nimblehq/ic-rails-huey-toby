# frozen_string_literal: true

module Api
  module V1
    class SearchResultsController < ApplicationController
      include Pagination

      def create
        if upload_form.valid?
          search_results = upload_form.save
          render_success(search_results)
        else
          render_failed(upload_form)
        end
      end

      def index
        search_result_list = SearchResult.where(user_id: current_user.id).order(:id)
        pagy, paginated_results = paginated_resources_for(search_result_list)

        search_result_data = SearchResultsSerializer.new(paginated_results).serializable_hash[:data]
        pagy_meta = meta_from_pagy(pagy)

        render json: { data: search_result_data, meta: pagy_meta }, status: :ok
      rescue Pagy::OverflowError
        render status: :not_found
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

      def render_success(search_results)
        success_message = I18n.t('activemodel.notices.models.search_result.create')
        search_results_data = SearchResultsSerializer.new(search_results, meta: { message: success_message })

        render json: search_results_data, status: :created
      end

      def render_failed(upload_form)
        # TODO: return error messages in JSON:API format
        render json: { errors: upload_form.errors.full_messages }, status: :unprocessable_entity
      end

      def meta_from_pagy(pagy)
        {
          page: pagy.page,
          pages: pagy.pages,
          page_size: pagy.items,
          records: pagy.count
        }
      end
    end
  end
end
