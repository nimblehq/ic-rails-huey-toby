# frozen_string_literal: true

require 'csv'

module Api
  module V1
    class UploadController < ApplicationController
      def create
        upload = Upload.new(
          search_engine: params[:search_engine],
          csv_file: params[:csv_file]
        )
        if upload.save
          render json: { message: I18n.t('upload.upload_success'), status: :ok }
        else
          render json: { errors: upload.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end
  end
end
