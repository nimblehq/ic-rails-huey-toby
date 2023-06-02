# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchResult, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:keyword) }
    it { is_expected.to validate_presence_of(:search_engine) }
  end

  describe 'error message' do
    it 'is invalid without a keyword' do
      search_result = described_class.new(keyword: nil)
      search_result.valid?
      expect(search_result.errors[:keyword]).to include("can't be blank")
    end

    it 'is invalid without a search engine' do
      search_result = described_class.new(search_engine: nil)
      search_result.valid?
      expect(search_result.errors[:search_engine]).to include("can't be blank")
    end
  end
end
