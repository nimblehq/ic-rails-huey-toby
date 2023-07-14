# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Omniauth Callbacks', type: :request do
  describe 'POST #google_oauth2' do
    context 'given the email is already taken by a google_oauth2 provider' do
      it 'renders a sign-in successful response' do
        Fabricate(:application)

        user = Fabricate(:user)
        Request::OmniAuthCallback.new(:google_oauth2).mock(uid: user.provider_uid)
        allow(User).to receive(:from_omniauth).and_return(user)
        allow(user).to receive(:persisted?).and_return(true)

        post '/api/v1/users/auth/google_oauth2/callback'

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['data']['type']).to eq('oauth_token')
      end
    end

    context 'given the email is already taken by an email provider' do
      it 'returns an error' do
        Fabricate(:application)

        user = Fabricate(:user)
        user.errors.add(:email, :taken)

        Request::OmniAuthCallback.new(:google_oauth2).mock(uid: user.provider_uid)
        allow(User).to receive(:from_omniauth).and_return(user)

        post '/api/v1/users/auth/google_oauth2/callback'

        expect(response).to have_http_status(:internal_server_error)
        expect(user.errors[:email]).to include('has already been taken')
      end
    end

    context 'given the email is NOT already taken' do
      it 'renders a sign-up successful response' do
        Fabricate(:application)

        user = Fabricate(:user)
        Request::OmniAuthCallback.new(:google_oauth2).mock(uid: user.provider_uid)
        allow(User).to receive(:from_omniauth).and_return(user)
        allow(user).to receive(:persisted?).and_return(false)

        post '/api/v1/users/auth/google_oauth2/callback'

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['data']['type']).to eq('oauth_token')
      end
    end
  end
end
