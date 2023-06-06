# frozen_string_literal: true

module Api
  module V1
    class SearchResultsController < ApplicationController
      def create
        upload_form = UploadForm.new(upload_form_params)
        if upload_form.valid?
          search_results = upload_form.save
          render json: {
            data: SearchResultsSerializer.new(search_results).serializable_hash[:data],
            meta: { message: I18n.t('upload_form.upload_success') }
          }, status: :created
        else
          render json: { errors: upload_form.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def upload_form_params
        params.permit(:search_engine, :csv_file)
      end
    end
  end
end
