# frozen_string_literal: true

require 'csv'

CSV_CONTENT_TYPE = 'text/csv'
CSV_COUNT_MIN = 1
CSV_COUNT_MAX = 1000

class UploadForm
  include ActiveModel::Validations

  attr_reader :search_engine, :csv_file

  validates :search_engine, presence: true
  validates :search_engine, inclusion: { in: SearchResult.search_engines.keys }
  validates :csv_file, presence: true

  validate :valid_content_type, if: -> { csv_file.present? }
  validate :valid_count, if: -> { csv_file.present? }

  def initialize(search_engine:, csv_file:)
    @search_engine = search_engine
    @csv_file = csv_file
  end

  def valid_content_type
    return if csv_file.content_type == CSV_CONTENT_TYPE

    add_error :invalid_extension
  end

  def valid_count
    return if CSV.read(csv_file.tempfile).count.between?(CSV_COUNT_MIN, CSV_COUNT_MAX)

    add_error :invalid_count
  end

  def add_error(type)
    errors.add(:base, I18n.t("activemodel.errors.models.search_result.attributes.csv_file.#{type}"))
  end

  def save
    content = csv_file.read
    keywords = CSV.parse(content).flatten.map(&:strip)

    search_results = keywords.map { |keyword| SearchResult.new(keyword: keyword, search_engine: search_engine) }
    SearchResult.import search_results

    search_results
  end
end
