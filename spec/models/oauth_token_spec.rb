# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthToken, type: :model do
  describe '.generate_access_token' do
    context 'given an user' do
      it 'returns the generated access token for user' do
        user = Fabricate(:user)
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)

        allow(Doorkeeper::AccessToken).to receive(:create).and_return(access_token)

        expect(described_class.generate_access_token(user)).to eq(access_token)
      end
    end
  end
end
