# frozen_string_literal: true

class User < ApplicationRecord
  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all,
           inverse_of: :user

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all,
           inverse_of: :user

  has_many :search_results, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :doorkeeper, :omniauthable, omniauth_providers: [:google_oauth2]

  enum provider: { email: 'email', google_oauth2: 'google_oauth2' }

  validates :provider, inclusion: { in: providers.keys }

  class << self
    def from_email(email, password)
      User.create(
        email: email,
        password: password,
        provider: User.providers[:email]
      )
    end

    def from_omniauth(auth)
      User.find_or_create_by(email: auth.info.email, provider: auth.provider) do |new_user|
        new_user.assign_attributes(
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          provider: auth.provider,
          provider_uid: auth&.uid,
          full_name: auth&.info&.name,
          avatar_url: auth&.info&.image
        )
      end
    end
  end
end
