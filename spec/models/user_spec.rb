# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.from_email' do
    context 'given an existing user is found' do
      it 'returns the existing user' do
        email = Faker::Internet.email
        password = Faker::Internet.password
        user = Fabricate(:user,
                         provider: described_class.providers[:email],
                         provider_uid: nil,
                         email: email,
                         full_name: nil,
                         avatar_url: nil)

        expect(described_class.from_email(email, password)).to eq(user)
      end
    end

    context 'given a new user' do
      it 'creates a new user with the provided attributes' do
        email = Faker::Internet.email
        password = Faker::Internet.password

        user = described_class.from_email(email, password)

        expect(user.provider).to eq(described_class.providers[:email])
        expect(user.provider_uid).to be_nil
        expect(user.email).to eq(email)
        expect(user.full_name).to be_nil
        expect(user.avatar_url).to be_nil
      end
    end
  end

  describe '.from_omniauth' do
    context 'given an existing user is found' do
      it 'returns the existing user' do
        auth = OmniAuth::AuthHash.new(Faker::Omniauth.google)
        user = Fabricate(:user,
                         provider: auth['provider'],
                         provider_uid: auth['uid'],
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
        expect(user.provider_uid).to eq(auth['uid'])
        expect(user.email).to eq(auth['info']['email'])
        expect(user.full_name).to eq(auth['info']['name'])
        expect(user.avatar_url).to eq(auth['info']['image'])
      end
    end
  end
end
