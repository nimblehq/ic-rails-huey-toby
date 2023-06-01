# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Upload, type: :model do
  describe '#save' do
    context 'given a valid search engine and csv file' do
      it 'returns true' do
        upload = described_class.new(
          search_engine: 'Google',
          csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
        )

        expect(upload.save).to be(true)
        expect(upload.errors).to be_empty
        expect(SearchResult.count).to eq(6)
      end
    end

    context 'given an invalid search engine' do
      it 'returns false' do
        upload = described_class.new(
          search_engine: 'Yahoo',
          csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
        )

        expect(upload.save).to be(false)
        expect(upload.errors.full_messages).to eq([I18n.t('upload.validation.search_engine_invalid')])
        expect(SearchResult.count).to eq(0)
      end
    end

    context 'given an empty csv file' do
      it 'returns false' do
        upload = described_class.new(
          search_engine: 'Google',
          csv_file: nil
        )

        expect(upload.save).to be(false)
        expect(upload.errors.full_messages).to eq([I18n.t('upload.validation.csv_file_empty')])
        expect(SearchResult.count).to eq(0)
      end
    end

    context 'given an invalid file extension' do
      it 'returns false' do
        upload = described_class.new(
          search_engine: 'Google',
          csv_file: fixture_file_upload('upload_invalid_extension.txt', 'text')
        )

        expect(upload.save).to be(false)
        expect(upload.errors.full_messages).to eq([I18n.t('upload.validation.csv_file_invalid_extension')])
        expect(SearchResult.count).to eq(0)
      end
    end

    context 'given an invalid file count' do
      it 'returns false' do
        upload = described_class.new(
          search_engine: 'Google',
          csv_file: fixture_file_upload('upload_invalid_count.csv', 'text/csv')
        )

        expect(upload.save).to be(false)
        expect(upload.errors.full_messages).to eq([I18n.t('upload.validation.csv_file_invalid_count')])
        expect(SearchResult.count).to eq(0)
      end
    end

    context 'given csv file can not be read' do
      it 'returns false' do
        csv_file = fixture_file_upload('upload_valid.csv', 'text/csv')
        allow(csv_file).to receive(:read).and_raise(StandardError)

        upload = described_class.new(search_engine: 'Google', csv_file: csv_file)

        expect(upload.save).to be(false)
        expect(upload.errors.full_messages).to eq([I18n.t('upload.validation.save_failed')])
        expect(SearchResult.count).to eq(0)
      end
    end
  end
end
