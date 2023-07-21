# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  attributes :email, :full_name, :avatar_url, :provider, :provider_uid, :confirmation_sent_at
end
