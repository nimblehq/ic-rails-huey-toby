# frozen_string_literal: true

require 'rails_helper'

# Reference: https://github.com/zquestz/omniauth-google-oauth2#auth-hash
OMNIAUTH_HASH = {
  'provider' => 'google_oauth2',
  'uid' => '100000000000000000000',
  'info' => {
    'name' => 'John Smith',
    'email' => 'john@example.com',
    'first_name' => 'John',
    'last_name' => 'Smith',
    'image' => 'https://lh4.googleusercontent.com/photo.jpg',
    'urls' => {
      'google' => 'https://plus.google.com/+JohnSmith'
    }
  },
  'credentials' => {
    'token' => 'TOKEN',
    'refresh_token' => 'REFRESH_TOKEN',
    'expires_at' => 1_496_117_119,
    'expires' => true
  },
  'extra' => {
    'id_token' => 'ID_TOKEN',
    'id_info' => {
      'azp' => 'APP_ID',
      'aud' => 'APP_ID',
      'sub' => '100000000000000000000',
      'email' => 'john@example.com',
      'email_verified' => true,
      'at_hash' => 'HK6E_P6Dh8Y93mRNtsDB1Q',
      'iss' => 'accounts.google.com',
      'iat' => 1_496_117_119,
      'exp' => 1_496_117_119
    },
    'raw_info' => {
      'sub' => '100000000000000000000',
      'name' => 'John Smith',
      'given_name' => 'John',
      'family_name' => 'Smith',
      'profile' => 'https://plus.google.com/+JohnSmith',
      'picture' => 'https://lh4.googleusercontent.com/photo.jpg?sz=50',
      'email' => 'john@example.com',
      'email_verified' => 'true',
      'locale' => 'en',
      'hd' => 'company.com'
    }
  }
}.freeze

RSpec.describe User, type: :model do
  describe '.from_omniauth' do
    context 'given an existing user is found' do
      it 'returns the existing user' do
        auth = OmniAuth::AuthHash.new(OMNIAUTH_HASH)

        existing_user = Fabricate(:user)
        expect(described_class.from_omniauth(auth)).to eq(existing_user)
      end
    end

    context 'given a new user is created' do
      it 'returns a new user with the provided attributes' do
        auth = OmniAuth::AuthHash.new(OMNIAUTH_HASH)

        described_class.from_omniauth(auth)

        expect(described_class.last.email).to eq('john@example.com')
        expect(described_class.last.full_name).to eq('John Smith')
        expect(described_class.last.avatar_url).to eq('https://lh4.googleusercontent.com/photo.jpg')
      end
    end
  end
end
