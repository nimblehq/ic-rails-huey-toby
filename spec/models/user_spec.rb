# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.from_omniauth' do
    context 'given an existing user is found' do
      it 'returns the existing user' do
        auth = OmniAuth::AuthHash.new(Faker::Omniauth.google)
        user = Fabricate(:user,
                         provider: auth['provider'],
                         uid: auth['uid'],
                         email: auth['info']['email'],
                         full_name: auth['info']['name'],
                         avatar_url: auth['info']['image'])

        expect(described_class.from_omniauth(auth)).to eq(user)
      end
    end

    context 'given a new user' do
      it 'creates a new user with the provided attributes' do
        auth = OmniAuth::AuthHash.new(Faker::Omniauth.google)

        user = described_class.from_omniauth(auth)

        expect(user.provider).to eq(auth['provider'])
        expect(user.uid).to eq(auth['uid'])
        expect(user.email).to eq(auth['info']['email'])
        expect(user.full_name).to eq(auth['info']['name'])
        expect(user.avatar_url).to eq(auth['info']['image'])
      end
    end
  end
end
