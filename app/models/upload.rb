# frozen_string_literal: true

gem 'activerecord-import'

class Upload
  include ActiveModel::Validations

  attr_accessor :search_engine, :csv_file

  validates_with UploadValidator

  def initialize(search_engine:, csv_file:)
    @search_engine = search_engine
    @csv_file = csv_file
  end

  def save
    return false unless valid?

    begin
      content = csv_file.read
      keywords = CSV.parse(content).flatten.map(&:strip)
      search_results = keywords.map { |keyword| SearchResult.new(keyword: keyword, search_engine: search_engine) }
      SearchResult.import search_results, validate: true, raise_error: true
    rescue StandardError
      errors.add(:base, I18n.t('upload.validation.save_failed'))
    end

    errors.empty?
  end
end
