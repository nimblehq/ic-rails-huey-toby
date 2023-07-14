# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Exports', type: :request do
  describe 'GET #export' do
    context 'given an existing search result ID' do
      it 'returns a successful response with PDF' do
        user = Fabricate(:user)
        authorization_header = create_authorization_header(user: user)
        search_result = Fabricate(:search_result, user_id: user.id)

        get '/api/v1/export', headers: authorization_header, params: { search_result_id: search_result.id }

        expect(response.content_type).to eq('application/pdf')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'given a NON-EXISTING search result ID' do
      it 'returns a not found error response with JSON' do
        user = Fabricate(:user)
        authorization_header = create_authorization_header(user: user)

        get '/api/v1/export', headers: authorization_header, params: { search_result_id: 'invalid_id' }

        expect(JSON.parse(response.body)['errors'][0]['detail']).to eq(I18n.t('activemodel.errors.models.search_result.not_found'))
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'given an UNAUTHENTICATED user' do
      it 'returns an unauthorized response with JSON' do
        get '/api/v1/export?search_result_id=1'

        expect(JSON.parse(response.body)['errors'][0]['detail']).to eq('The access token is invalid')
        expect(JSON.parse(response.body)['errors'][0]['code']).to eq('invalid_token')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
