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

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :doorkeeper, :omniauthable, omniauth_providers: [:google_oauth2]

  enum provider: { email: 'email', google_oauth2: 'google_oauth2' }

  validates :provider, inclusion: { in: providers.keys }

  class << self
    def from_email(email, password)
      user = find_or_initialize_user(
        email: email,
        password: password,
        provider: User.providers[:email]
      )

      user.persisted? ? user.errors.add(:email, :taken) : user.save

      user
    end

    def from_omniauth(auth)
      user = find_or_initialize_user(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        provider: auth.provider,
        auth: auth
      )

      user.provider == User.providers[:email] ? user.errors.add(:email, :taken) : user.persisted? || user.save

      user
    end

    def find_or_initialize_user(email:, password:, provider:, auth: nil)
      User.find_or_initialize_by(email: email) do |new_user|
        new_user.assign_attributes(
          email: email,
          password: password,
          provider: provider,
          provider_uid: auth&.uid,
          full_name: auth&.info&.name,
          avatar_url: auth&.info&.image
        )
      end
    end
  end
end
