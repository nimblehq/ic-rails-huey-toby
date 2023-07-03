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

  class << self
    def from_omniauth(auth)
      User.find_or_create_by(provider: auth.provider, uid: auth.uid, email: auth.info.email) do |user|
        set_user_attributes(user, auth)
      end
    end

    private

    def set_user_attributes(user, auth)
      user.provider = auth.provider
      user.uid = auth.uid

      profile = auth.info
      user.email = profile.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = profile.name
      user.avatar_url = profile&.image
    end
  end
end
