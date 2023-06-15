# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchResult, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:keyword) }

    it { is_expected.to validate_presence_of(:search_engine) }

    it { is_expected.to validate_presence_of(:status) }

    it 'is INVALID without a keyword' do
      search_result = described_class.new(keyword: nil)

      search_result.valid?

      expect(search_result.errors[:keyword]).to include("can't be blank")
    end

    it 'is INVALID without a search engine' do
      search_result = described_class.new(search_engine: nil)

      search_result.valid?

      expect(search_result.errors[:search_engine]).to include("can't be blank")
    end

    it 'is INVALID with the wrong search engine' do
      search_result = described_class.new(search_engine: 'yahoo')

      search_result.valid?

      expect(search_result.errors[:search_engine]).to include('is not included in the list')
    end

    it 'is INVALID without a status' do
      search_result = described_class.new(status: nil)
      search_result.valid?
      expect(search_result.errors[:status]).to include("can't be blank")
    end

    it 'is INVALID with the wrong status' do
      search_result = described_class.new(status: 'running')
      search_result.valid?
      expect(search_result.errors[:search_engine]).to include('is not included in the list')
    end

    it 'has a default status' do
      search_result = described_class.create(keyword: 'keyword', search_engine: 'google')
      expect(search_result.status).to eq('in_progress')
    end
  end
end
