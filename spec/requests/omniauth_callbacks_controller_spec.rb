# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Omniauth Callbacks', type: :request do
  describe 'POST #google_oauth2' do
    context 'given the email is available' do
      it 'renders a sign-in successful response' do
        application = Fabricate(:application)
        allow(Doorkeeper::Application).to receive(:first).and_return(application)

        user = Fabricate(:user)
        Request::OmniAuthCallback.new(:google_oauth2).mock(uid: user.uid)
        allow(User).to receive(:from_omniauth).and_return(user)
        allow(user).to receive(:persisted?).and_return(true)

        post '/api/v1/users/auth/google_oauth2/callback'

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['data']['type']).to eq('oauth_token')
        expect(JSON.parse(response.body)['meta']['message']).to eq(I18n.t('activemodel.notices.models.user.sign_in'))
      end
    end

    context 'given the email is NOT available' do
      it 'renders a sign-up successful response' do
        application = Fabricate(:application)
        allow(Doorkeeper::Application).to receive(:first).and_return(application)

        user = Fabricate(:user)
        Request::OmniAuthCallback.new(:google_oauth2).mock(uid: user.uid)
        allow(User).to receive(:from_omniauth).and_return(user)
        allow(user).to receive(:persisted?).and_return(false)

        post '/api/v1/users/auth/google_oauth2/callback'

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['data']['type']).to eq('oauth_token')
        expect(JSON.parse(response.body)['meta']['message']).to eq(I18n.t('activemodel.notices.models.user.sign_up'))
      end
    end
  end
end
