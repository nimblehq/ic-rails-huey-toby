# frozen_string_literal: true

class OauthToken < ApplicationRecord
  class << self
    # Generate token manually to automatically log a user in after registering
    # https://github.com/doorkeeper-gem/doorkeeper/issues/846#issuecomment-230297646
    def generate_access_token(user)
      Doorkeeper::AccessToken.create(
        application_id: Doorkeeper::Application.first.id,
        resource_owner_id: user.id,
        refresh_token: Doorkeeper::OAuth::Helpers::UniqueToken.generate,
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: Doorkeeper.configuration.default_scopes
      )
    end
  end
end
