# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Upload Endpoint', type: :request do
  describe 'POST #create' do
    context 'given a valid search engine and csv file' do
      it 'returns a successful response with JSON' do
        post '/api/v1/upload', params: { search_engine: 'Google', csv_file: fixture_file_upload('upload_valid.csv', 'text/csv') }

        expect(response.body).to eq({ message: I18n.t('upload.upload_success'), status: :ok }.to_json)
        expect(SearchResult.count).to eq(6)
      end
    end

    context 'given an empty search engine' do
      it 'returns an unsuccessful response with JSON' do
        post '/api/v1/upload', params: { search_engine: nil, csv_file: fixture_file_upload('upload_valid.csv', 'text/csv') }

        expect(response.body).to eq({ errors: [I18n.t('upload.validation.search_engine_empty')], status: :unprocessable_entity }.to_json)
        expect(SearchResult.count).to eq(0)
      end
    end

    context 'given an invalid search engine' do
      it 'returns an unsuccessful response with JSON' do
        post '/api/v1/upload', params: { search_engine: 'Yahoo', csv_file: fixture_file_upload('upload_valid.csv', 'text/csv') }

        expect(response.body).to eq({ errors: [I18n.t('upload.validation.search_engine_invalid')], status: :unprocessable_entity }.to_json)
        expect(SearchResult.count).to eq(0)
      end
    end

    context 'given an empty csv file' do
      it 'returns an unsuccessful response with JSON' do
        post '/api/v1/upload', params: { search_engine: 'Google', csv_file: nil }

        expect(response.body).to eq({ errors: [I18n.t('upload.validation.csv_file_empty')], status: :unprocessable_entity }.to_json)
        expect(SearchResult.count).to eq(0)
      end
    end

    context 'given an invalid file extension' do
      it 'returns an unsuccessful response with JSON' do
        post '/api/v1/upload', params: { search_engine: 'Google', csv_file: fixture_file_upload('upload_invalid_extension.txt', 'text') }

        expect(response.body).to eq({ errors: [I18n.t('upload.validation.csv_file_invalid_extension')], status: :unprocessable_entity }.to_json)
        expect(SearchResult.count).to eq(0)
      end
    end

    context 'given an invalid file count' do
      it 'returns an unsuccessful response with JSON' do
        post '/api/v1/upload', params: { search_engine: 'Google', csv_file: fixture_file_upload('upload_invalid_count.csv', 'text/csv') }

        expect(response.body).to eq({ errors: [I18n.t('upload.validation.csv_file_invalid_count')], status: :unprocessable_entity }.to_json)
        expect(SearchResult.count).to eq(0)
      end
    end
  end
end
