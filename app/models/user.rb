# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    find_existing_user(auth) || create_new_user(auth)
  end

  private_class_method def self.find_existing_user(auth)
    where(provider: auth.provider, uid: auth.uid, email: auth.info.email).first
  end

  private_class_method def self.create_new_user(auth)
    create do |user|
      set_user_attributes(user, auth)
    end
  end

  private_class_method def self.set_user_attributes(user, auth)
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.full_name = auth.info.name
    user.avatar_url = auth.info.image
  end
end
