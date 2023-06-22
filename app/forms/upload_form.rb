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

  validate :csv_file_content_type, if: -> { csv_file.present? }
  validate :keyword_count, if: -> { csv_file.present? && csv? }

  def initialize(search_engine:, csv_file:)
    @search_engine = search_engine
    @csv_file = csv_file
  end

  def save
    content = csv_file.read
    keywords = CSV.parse(content).flatten.map(&:strip)

    keywords
      .map { |keyword| SearchResult.new(keyword: keyword, search_engine: search_engine) }
      .tap { |results| save_search_results(results) }
      .tap { |results| scrape_search_results(results) }
  end

  private

  def save_search_results(results)
    SearchResult.import(results, raise_error: true)
  end

  def scrape_search_results(results)
    search_result_ids = results.map(&:id)
    DistributeSearchKeywordJob.perform_later(search_result_ids)
  end

  def csv_file_content_type
    return if csv?

    errors.add(:csv_file, :invalid_extension)
  end

  def csv?
    csv_file.content_type == CSV_CONTENT_TYPE
  end

  def keyword_count
    return if CSV.read(csv_file.tempfile).count.between?(CSV_COUNT_MIN, CSV_COUNT_MAX)

    errors.add(:csv_file, :invalid_count)
  end
end
