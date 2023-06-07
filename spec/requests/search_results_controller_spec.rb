# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search Results', type: :request do
  describe 'POST #create' do
    context 'given a valid search engine and csv file' do
      it 'returns a successful response with JSON' do
        post '/api/v1/upload', params: {
          search_engine: 'google',
          csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
        }

        expect(JSON.parse(response.body)['data'][0]['type']).to eq('search_results')
        expect(JSON.parse(response.body)['meta']['message']).to eq(I18n.t('activemodel.notices.models.search_result.create'))
        expect(response).to have_http_status(:created)
      end
    end

    context 'given an empty search engine' do
      it 'returns an unsuccessful response with JSON' do
        post '/api/v1/upload', params: {
          search_engine: nil,
          csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
        }

        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'given an invalid search engine' do
      it 'returns an unsuccessful response with JSON' do
        post '/api/v1/upload', params: {
          search_engine: 'yahoo',
          csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
        }

        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'given an empty csv file' do
      it 'returns an unsuccessful response with JSON' do
        post '/api/v1/upload', params: {
          search_engine: 'google',
          csv_file: nil
        }

        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'given an invalid file extension' do
      it 'returns an unsuccessful response with JSON' do
        post '/api/v1/upload', params: {
          search_engine: 'google',
          csv_file: fixture_file_upload('upload_invalid_extension.txt', 'text/plain')
        }

        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'given an invalid file count' do
      it 'returns an unsuccessful response with JSON' do
        post '/api/v1/upload', params: {
          search_engine: 'google',
          csv_file: fixture_file_upload('upload_invalid_count.csv', 'text/csv')
        }

        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
