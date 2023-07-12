# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'POST #create' do
    context 'given the email is available' do
      it 'renders a sign-up successful response' do
        application = Fabricate(:application)
        allow(Doorkeeper::Application).to receive(:first).and_return(application)

        user = Fabricate(:user)
        allow(User).to receive(:from_email).and_return(user)

        post '/api/v1/users', params: {
          user: { email: user.email, password: user.password },
          client_id: 'client_id',
          client_secret: 'client_secret'
        }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['data']['type']).to eq('user')
      end
    end

    context 'given the email is NOT available' do
      it 'returns an 422 error' do
        application = Fabricate(:application)
        allow(Doorkeeper::Application).to receive(:first).and_return(application)

        user = Fabricate(:user)
        user.errors.add(:email, :taken)
        allow(User).to receive(:from_email).and_return(user)

        post '/api/v1/users', params: {
          user: { email: user.email, password: user.password },
          client_id: 'client_id',
          client_secret: 'client_secret'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(user.errors[:email]).to include('has already been taken')
      end
    end

    context 'given the client is NOT correct' do
      it 'returns an 403 error' do
        application = Fabricate(:application)
        allow(Doorkeeper::Application).to receive(:first).and_return(application)

        user = Fabricate(:user)
        allow(User).to receive(:from_email).and_return(user)

        post '/api/v1/users', params: {
          user: { email: user.email, password: user.password },
          client_id: 'incorrect_client_id',
          client_secret: 'incorrect_client_secret'
        }

        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['errors']).to eq(I18n.t('doorkeeper.errors.messages.invalid_client'))
      end
    end
  end
end
