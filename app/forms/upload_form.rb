# frozen_string_literal: true

require 'csv'

class UploadForm
  include ActiveModel::Validations

  attr_reader :search_engine, :csv_file

  validates :search_engine, presence: true
  validates :search_engine, inclusion: { in: SearchResult.search_engines.keys }
  validates :csv_file, presence: true

  validate :valid_content_type, if: -> { csv_file.present? }
  validate :valid_count, if: -> { csv_file.present? }

  def initialize(params)
    @search_engine = params[:search_engine]
    @csv_file = params[:csv_file]
  end

  def valid_content_type
    return if csv_file.content_type == 'text/csv'

    add_error :csv_file_invalid_extension
  end

  def valid_count
    return if CSV.read(csv_file.tempfile).count.between?(1, 1000)

    add_error :csv_file_invalid_count
  end

  def add_error(type)
    errors.add(:base, I18n.t("upload_form.validation.#{type}"))
  end

  def save
    content = csv_file.read
    keywords = CSV.parse(content).flatten.map(&:strip)

    search_results = keywords.map { |keyword| SearchResult.new(keyword: keyword, search_engine: search_engine) }
    SearchResult.import search_results

    search_results
  end
end
