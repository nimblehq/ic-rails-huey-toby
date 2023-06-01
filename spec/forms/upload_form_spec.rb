# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UploadForm, type: :model do
  describe '#valid?' do
    context 'given valid attributes' do
      it 'is valid' do
        upload_form = described_class.new(
          search_engine: 'google',
          csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
        )

        expect(upload_form).to be_valid
      end
    end

    context 'given search_engine is missing' do
      it 'is invalid' do
        upload_form = described_class.new(
          search_engine: nil,
          csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
        )

        expect(upload_form).not_to be_valid
        expect(upload_form.errors[:search_engine]).to include("can't be blank")
      end
    end

    context 'given search_engine is invalid' do
      it 'is invalid' do
        upload_form = described_class.new(
          search_engine: 'yahoo',
          csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
        )

        expect(upload_form).not_to be_valid
        expect(upload_form.errors[:search_engine]).to include('is not included in the list')
      end
    end

    context 'given csv_file is missing' do
      it 'is invalid' do
        upload_form = described_class.new(
          search_engine: 'google',
          csv_file: nil
        )

        expect(upload_form).not_to be_valid
        expect(upload_form.errors[:csv_file]).to include("can't be blank")
      end
    end

    context 'given csv_file has an invalid content type' do
      it 'is invalid' do
        upload_form = described_class.new(
          search_engine: 'google',
          csv_file: fixture_file_upload('upload_invalid_extension.txt', 'text/plain')
        )

        expect(upload_form).not_to be_valid
        expect(upload_form.errors[:base]).to eq([I18n.t('activemodel.errors.models.search_result.attributes.csv_file.invalid_extension')])
      end
    end

    context 'given csv_file has an invalid count' do
      it 'is invalid' do
        upload_form = described_class.new(
          search_engine: 'google',
          csv_file: fixture_file_upload('upload_invalid_count.csv', 'text/csv')
        )

        expect(upload_form).not_to be_valid
        expect(upload_form.errors[:base]).to eq([I18n.t('activemodel.errors.models.search_result.attributes.csv_file.invalid_count')])
      end
    end
  end

  describe '#save' do
    context 'given valid attributes' do
      it 'creates search results' do
        upload_form = described_class.new(
          search_engine: 'google',
          csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
        )

        expect { upload_form.save }.to change(SearchResult, :count).by(6)
      end
    end

    context 'given any attribute is invalid' do
      it 'does not create search results' do
        upload_form = described_class.new(
          search_engine: 'yahoo',
          csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
        )

        expect { upload_form.save }.not_to change(SearchResult, :count)
      end
    end
  end
end