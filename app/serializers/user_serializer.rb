# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  attributes :email, :full_name, :avatar_url, :provider, :provider_uid
end
