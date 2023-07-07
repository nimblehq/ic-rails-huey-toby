# frozen_string_literal: true

class OauthTokenSerializer
  include JSONAPI::Serializer

  attributes :token, :token_type, :refresh_token, :expires_in, :created_at
end
