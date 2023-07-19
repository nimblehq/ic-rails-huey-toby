# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search Results', type: :request do
  describe 'POST #create' do
    context 'given an authenticated user' do
      context 'given a valid search engine and csv file' do
        it 'returns a successful response with JSON' do
          authorization_header = create_authorization_header(user: Fabricate(:user))
          params = { search_engine: 'google', csv_file: fixture_file_upload('upload_valid.csv', 'text/csv') }

          post '/api/v1/upload', headers: authorization_header, params: params

          expect(JSON.parse(response.body)['data'][0]['type']).to eq('search_result_list')
          expect(JSON.parse(response.body)['meta']['message']).to eq(I18n.t('activemodel.notices.models.search_result.create'))
          expect(response).to have_http_status(:created)
        end
      end

      context 'given NO search engine' do
        it 'returns an unsuccessful response with JSON' do
          authorization_header = create_authorization_header(user: Fabricate(:user))
          params = { search_engine: nil, csv_file: fixture_file_upload('upload_valid.csv', 'text/csv') }

          post '/api/v1/upload', headers: authorization_header, params: params

          expect(JSON.parse(response.body).keys).to contain_exactly('errors')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'given INVALID search engine' do
        it 'returns an unsuccessful response with JSON' do
          authorization_header = create_authorization_header(user: Fabricate(:user))
          params = { search_engine: 'yahoo', csv_file: fixture_file_upload('upload_valid.csv', 'text/csv') }

          post '/api/v1/upload', headers: authorization_header, params: params

          expect(JSON.parse(response.body).keys).to contain_exactly('errors')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'given NO csv file' do
        it 'returns an unsuccessful response with JSON' do
          authorization_header = create_authorization_header(user: Fabricate(:user))
          params = { search_engine: 'google', csv_file: nil }

          post '/api/v1/upload', headers: authorization_header, params: params

          expect(JSON.parse(response.body).keys).to contain_exactly('errors')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'given INVALID file extension' do
        it 'returns an unsuccessful response with JSON' do
          authorization_header = create_authorization_header(user: Fabricate(:user))
          params = { search_engine: 'google', csv_file: fixture_file_upload('upload_invalid_extension.txt', 'text/plain') }

          post '/api/v1/upload', headers: authorization_header, params: params

          expect(JSON.parse(response.body).keys).to contain_exactly('errors')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'given INVALID file count' do
        it 'returns an unsuccessful response with JSON' do
          authorization_header = create_authorization_header(user: Fabricate(:user))
          params = { search_engine: 'google', csv_file: fixture_file_upload('upload_invalid_count.csv', 'text/csv') }

          post '/api/v1/upload', headers: authorization_header, params: params

          expect(JSON.parse(response.body).keys).to contain_exactly('errors')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'given a valid params with url_equals filter' do
      it 'returns a successful response with JSON' do
        user = Fabricate(:user)

        # Expected matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['www.nimblehq.co'])

        # Non-matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass'])
        Fabricate(:search_result, user_id: user.id, adwords_top_urls: ['www.nimblehq.co/compass'])

        authorization_header = create_authorization_header(user: user)
        params = { page: { number: 1, size: 20 }, filter: { url_equals: 'www.nimblehq.co' } }

        get '/api/v1/search_results', headers: authorization_header, params: params

        expect(JSON.parse(response.body)['data'][0]['type']).to eq('search_result_list')
        expect(JSON.parse(response.body)['meta']['page']).to eq(1)
        expect(JSON.parse(response.body)['meta']['pages']).to eq(1)
        expect(JSON.parse(response.body)['meta']['page_size']).to eq(20)
        expect(JSON.parse(response.body)['meta']['records']).to eq(2)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'given a valid params with url_contains_at_least_one filter' do
      it 'returns a successful response with JSON' do
        user = Fabricate(:user)

        # Expected matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: [], adwords_top_urls: ['www.nimblehq.co/compass'])
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass'], adwords_top_urls: [])

        # Non-matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co'], adwords_top_urls: [])
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: [], adwords_top_urls: ['www.nimblehq.co'])

        authorization_header = create_authorization_header(user: user)
        params = { page: { number: 1, size: 20 }, filter: { url_contains_at_least_one: '/' } }

        get '/api/v1/search_results', headers: authorization_header, params: params

        expect(JSON.parse(response.body)['data'][0]['type']).to eq('search_result_list')
        expect(JSON.parse(response.body)['meta']['page']).to eq(1)
        expect(JSON.parse(response.body)['meta']['pages']).to eq(1)
        expect(JSON.parse(response.body)['meta']['page_size']).to eq(20)
        expect(JSON.parse(response.body)['meta']['records']).to eq(2)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'given a valid params with url_contains_at_least_two filter' do
      it 'returns a successful response with JSON' do
        user = Fabricate(:user)

        # Expected matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass/development/code-conventions'], adwords_top_urls: [])
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: ['www.nimblehq.co/compass/development'], adwords_top_urls: [])

        # Non-matches
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: [], adwords_top_urls: ['www.nimblehq.co/compass'])
        Fabricate(:search_result, user_id: user.id, non_adwords_urls: [], adwords_top_urls: ['www.nimblehq.co'])

        authorization_header = create_authorization_header(user: user)
        params = { page: { number: 1, size: 20 }, filter: { url_contains_at_least_two: '/' } }

        get '/api/v1/search_results', headers: authorization_header, params: params

        expect(JSON.parse(response.body)['data'][0]['type']).to eq('search_result_list')
        expect(JSON.parse(response.body)['meta']['page']).to eq(1)
        expect(JSON.parse(response.body)['meta']['pages']).to eq(1)
        expect(JSON.parse(response.body)['meta']['page_size']).to eq(20)
        expect(JSON.parse(response.body)['meta']['records']).to eq(2)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'given an UNAUTHENTICATED user' do
      it 'returns an unauthorized response with JSON' do
        params = { search_engine: 'google', csv_file: fixture_file_upload('upload_valid.csv', 'text/csv') }

        post '/api/v1/upload', params: params

        expect(JSON.parse(response.body)['errors'][0]['detail']).to eq('The access token is invalid')
        expect(JSON.parse(response.body)['errors'][0]['code']).to eq('invalid_token')
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
          authorization_header = create_authorization_header(user: user)

          get '/api/v1/search_results', headers: authorization_header

          expect(JSON.parse(response.body)['data'][0]['type']).to eq('search_result_list')
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
          authorization_header = create_authorization_header(user: user)
          params = { page: { number: 1, size: 20 } }

          get '/api/v1/search_results', headers: authorization_header, params: params

          expect(JSON.parse(response.body)['data'][0]['type']).to eq('search_result_list')
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

        expect(JSON.parse(response.body)['errors'][0]['detail']).to eq('The access token is invalid')
        expect(JSON.parse(response.body)['errors'][0]['code']).to eq('invalid_token')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    context 'given an existing search result ID' do
      it 'returns a successful response with JSON' do
        user = Fabricate(:user)
        authorization_header = create_authorization_header(user: user)
        search_result = Fabricate(:search_result, id: 1, user_id: user.id)

        get '/api/v1/search_results/1', headers: authorization_header

        expect(JSON.parse(response.body)['data']['type']).to eq('search_result')
        expect(JSON.parse(response.body)['data']['id']).to eq(search_result.id.to_s)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'given a NON-EXISTING search result ID' do
      it 'returns a not found error response with JSON' do
        user = Fabricate(:user)
        Fabricate.times(20, :search_result, user_id: user.id)
        authorization_header = create_authorization_header(user: user)

        get '/api/v1/search_results/9999', headers: authorization_header

        expect(JSON.parse(response.body)['errors'][0]['detail']).to eq('No Search result found.')
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'given an UNAUTHENTICATED user' do
      it 'returns an unauthorized response with JSON' do
        get '/api/v1/search_results/1'

        expect(JSON.parse(response.body)['errors'][0]['detail']).to eq('The access token is invalid')
        expect(JSON.parse(response.body)['errors'][0]['code']).to eq('invalid_token')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
