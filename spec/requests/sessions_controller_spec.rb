# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'POST #create' do
    context 'given a valid e-mail' do
      it 'returns a successful response with JSON' do
        Fabricate(:application)

        user = Fabricate(:user, provider: User.providers[:email])

        post '/api/v1/users/sign_in', params: {
          user: { email: user.email, password: user.password },
          client_id: 'client_id',
          client_secret: 'client_secret'
        }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['data']['type']).to eq('oauth_token')
      end
    end

    context 'given an INVALID e-mail' do
      it 'returns an unauthorized response with JSON' do
        Fabricate(:application)

        user = Fabricate(:user, provider: User.providers[:email])

        post '/api/v1/users/sign_in', params: {
          user: { email: 'incorrect_email@nimblehq.co', password: user.password },
          client_id: 'client_id',
          client_secret: 'client_secret'
        }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors'][0]['detail']).to include(I18n.t('devise.failure.invalid', authentication_keys: :email))
      end
    end

    context 'given an INVALID password' do
      it 'returns an unauthorized response with JSON' do
        Fabricate(:application)

        user = Fabricate(:user, provider: User.providers[:email])

        post '/api/v1/users/sign_in', params: {
          user: { email: user.email, password: 'incorrect password' },
          client_id: 'client_id',
          client_secret: 'client_secret'
        }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors'][0]['detail']).to include(I18n.t('devise.failure.invalid', authentication_keys: :email))
      end
    end

    context 'given an INVALID provider' do
      it 'returns an unauthorized response with JSON' do
        application = Fabricate(:application)
        allow(Doorkeeper::Application).to receive(:first).and_return(application)

        user = Fabricate(:user, provider: User.providers[:google_oauth2])

        post '/api/v1/users/sign_in', params: {
          user: { email: user.email, password: user.password },
          client_id: 'client_id',
          client_secret: 'client_secret'
        }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors'][0]['detail']).to include(I18n.t('devise.failure.invalid', authentication_keys: :email))
      end
    end

    context 'given the e-mail has NOT been confirmed yet' do
      it 'returns an unauthorized response with JSON' do
        application = Fabricate(:application)
        allow(Doorkeeper::Application).to receive(:first).and_return(application)

        user = Fabricate(:user, provider: User.providers[:email], confirmed_at: nil)

        post '/api/v1/users/sign_in', params: {
          user: { email: user.email, password: user.password },
          client_id: 'client_id',
          client_secret: 'client_secret'
        }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors'][0]['detail']).to include(I18n.t('devise.failure.unconfirmed'))
      end
    end

    context 'given an INVALID client' do
      it 'returns a forbidden response with JSON' do
        Fabricate(:application)

        user = Fabricate(:user, provider: User.providers[:email])

        post '/api/v1/users', params: {
          user: { email: user.email, password: user.password },
          client_id: 'incorrect_client_id',
          client_secret: 'incorrect_client_secret'
        }

        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['errors'][0]['detail']).to eq(I18n.t('doorkeeper.errors.messages.invalid_client'))
      end
    end
  end
end
