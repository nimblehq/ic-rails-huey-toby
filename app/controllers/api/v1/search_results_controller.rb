# frozen_string_literal: true

module Api
  module V1
    class SearchResultsController < ApplicationController
      include Pagy::Backend

      before_action :doorkeeper_authorize!

      def create
        upload_form = create_upload_form

        if upload_form.valid?
          search_results = upload_form.save
          render_success(search_results)
        else
          render_failed(upload_form)
        end
      end

      # TODO: Consider create form object
      def index
        @pagy, @search_results = pagy(SearchResult.order(:id).where(user_id: current_user.id), pagination_params)

        data = SearchResultsSerializer.new(@search_results).serializable_hash[:data]
        meta = meta_from_pagy(@pagy)

        render json: { data: data, meta: meta }, status: :ok
      rescue Pagy::OverflowError
        render status: :not_found
      end

      private

      def current_user
        @current_user = User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

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

      def pagination_params
        {
          page: params.dig(:page, :number) || Pagy::DEFAULT[:page],
          items: params.dig(:page, :size) || Pagy::DEFAULT[:items]
        }
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
