# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search Results', type: :request do
  describe 'POST #create' do
    context 'given an authenticated user' do
      context 'given a valid search engine and csv file' do
        it 'returns a successful response with JSON' do
          user = Fabricate(:user)
          post_authenticated_request(user: user, endpoint: '/api/v1/upload',
                                     params: {
                                       search_engine: 'google',
                                       csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
                                     })

          expect(JSON.parse(response.body)['data'][0]['type']).to eq('search_results')
          expect(JSON.parse(response.body)['meta']['message']).to eq(I18n.t('activemodel.notices.models.search_result.create'))
          expect(response).to have_http_status(:created)
        end
      end

      context 'given NO search engine' do
        it 'returns an unsuccessful response with JSON' do
          user = Fabricate(:user)
          post_authenticated_request(user: user, endpoint: '/api/v1/upload',
                                     params: {
                                       search_engine: nil,
                                       csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
                                     })

          expect(JSON.parse(response.body).keys).to contain_exactly('errors')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'given INVALID search engine' do
        it 'returns an unsuccessful response with JSON' do
          user = Fabricate(:user)
          post_authenticated_request(user: user, endpoint: '/api/v1/upload',
                                     params: {
                                       search_engine: 'yahoo',
                                       csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
                                     })

          expect(JSON.parse(response.body).keys).to contain_exactly('errors')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'given NO csv file' do
        it 'returns an unsuccessful response with JSON' do
          user = Fabricate(:user)
          post_authenticated_request(user: user, endpoint: '/api/v1/upload',
                                     params: {
                                       search_engine: 'google',
                                       csv_file: nil
                                     })

          expect(JSON.parse(response.body).keys).to contain_exactly('errors')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'given INVALID file extension' do
        it 'returns an unsuccessful response with JSON' do
          user = Fabricate(:user)
          post_authenticated_request(user: user, endpoint: '/api/v1/upload',
                                     params: {
                                       search_engine: 'google',
                                       csv_file: fixture_file_upload('upload_invalid_extension.txt', 'text/plain')
                                     })

          expect(JSON.parse(response.body).keys).to contain_exactly('errors')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'given INVALID file count' do
        it 'returns an unsuccessful response with JSON' do
          user = Fabricate(:user)
          post_authenticated_request(user: user, endpoint: '/api/v1/upload',
                                     params: {
                                       search_engine: 'google',
                                       csv_file: fixture_file_upload('upload_invalid_count.csv', 'text/csv')
                                     })

          expect(JSON.parse(response.body).keys).to contain_exactly('errors')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'given an UNAUTHENTICATED user' do
      it 'returns an unauthorized response with JSON' do
        post '/api/v1/upload',
             params: {
               search_engine: 'google',
               csv_file: fixture_file_upload('upload_valid.csv', 'text/csv')
             }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #search_results' do
    context 'given an authenticated user' do
      context 'given a empty params' do
        it 'returns a successful response with JSON' do
          user = Fabricate(:user)
          Fabricate.times(20, :search_result, user_id: user.id)
          get_authenticated_request(user: user, endpoint: '/api/v1/search_results')

          expect(JSON.parse(response.body)['data'][0]['type']).to eq('search_results')
          expect(JSON.parse(response.body)['meta']['page']).to eq(1)
          expect(JSON.parse(response.body)['meta']['pages']).to eq(2)
          expect(JSON.parse(response.body)['meta']['page_size']).to eq(10)
          expect(JSON.parse(response.body)['meta']['records']).to eq(20)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'given a valid params' do
        it 'returns a successful response with JSON' do
          user = Fabricate(:user)
          Fabricate.times(20, :search_result, user_id: user.id)
          get_authenticated_request(user: user, endpoint: '/api/v1/search_results', params: { page: { number: 1, size: 20 } })

          expect(JSON.parse(response.body)['data'][0]['type']).to eq('search_results')
          expect(JSON.parse(response.body)['meta']['page']).to eq(1)
          expect(JSON.parse(response.body)['meta']['pages']).to eq(1)
          expect(JSON.parse(response.body)['meta']['page_size']).to eq(20)
          expect(JSON.parse(response.body)['meta']['records']).to eq(20)
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'given an UNAUTHENTICATED user' do
      it 'returns an unauthorized response with JSON' do
        get '/api/v1/search_results'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
