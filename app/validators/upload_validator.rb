# frozen_string_literal: true

require 'csv'

class UploadValidator < ActiveModel::Validator
  def validate(upload)
    @upload = upload

    validate_search_engine
    validate_csv_file
  end

  private

  attr_reader :upload

  def search_engine
    upload.search_engine
  end

  def csv_file
    upload.csv_file
  end

  def validate_search_engine
    if search_engine.blank?
      add_error :search_engine_empty
    elsif !search_engine.in?(SearchResult.search_engines.keys)
      add_error :search_engine_invalid
    end
  end

  def validate_csv_file
    if csv_file.blank?
      add_error :csv_file_empty
    elsif !valid_content_type?
      add_error :csv_file_invalid_extension
    elsif !valid_count?
      add_error :csv_file_invalid_count
    end
  end

  def valid_content_type?
    csv_file.content_type == 'text/csv'
  end

  def valid_count?
    CSV.read(csv_file.tempfile).count.between?(1, 1000)
  end

  def add_error(type)
    upload.errors.add(:base, I18n.t("upload.validation.#{type}"))
  end
end
