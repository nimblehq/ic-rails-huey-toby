# frozen_string_literal: true

module Api
  module V1
    class SearchResultsController < ApplicationController
      def create
        upload_form = create_upload_form

        if upload_form.valid?
          search_results = upload_form.save
          render_success(search_results)
        else
          render_failed(upload_form)
        end
      end

      def index
        search_results_form = SearchResultForm.new(user_id: current_user.id)
        paginated_results = search_results_form.paginated_results(params: params)

        search_result_data = SearchResultsSerializer.new(paginated_results[:results]).serializable_hash[:data]
        pagy_meta = meta_from_pagy(paginated_results[:pagy])

        render json: { data: search_result_data, meta: pagy_meta }, status: :ok
      rescue Pagy::OverflowError
        render status: :not_found
      end

      private

      def create_upload_form
        UploadForm.new(
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
