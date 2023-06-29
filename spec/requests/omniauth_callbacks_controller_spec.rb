# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Omniauth Callbacks', type: :request do
  describe 'POST #google_oauth2' do
    context 'given the email is available' do
      it 'renders a successful response' do
        user = Fabricate(:user)
        Request::OmniAuthCallback.new(:google_oauth2).mock uid: user.uid
        allow(User).to receive(:from_omniauth).and_return(user)
        allow(user).to receive(:persisted?).and_return(true)

        post '/api/v1/users/auth/google_oauth2/callback'

        expect(response).to have_http_status(:success)
        expect(response.body).to eq({ success: true }.to_json)
      end
    end

    context 'given the email is NOT available' do
      it 'renders an unprocessable entity response with errors' do
        user = Fabricate(:user)
        Request::OmniAuthCallback.new(:google_oauth2).mock uid: user.uid
        allow(User).to receive(:from_omniauth).and_return(user)
        allow(user).to receive(:persisted?).and_return(false)
        allow(user.errors).to receive(:full_messages).and_return(['Email has already been taken'])

        post '/api/v1/users/auth/google_oauth2/callback'

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq({ errors: ['Email has already been taken'] }.to_json)
      end
    end
  end
end
