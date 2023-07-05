# frozen_string_literal: true

class OauthToken < ApplicationRecord
  OAUTH_APPLICATION_NAME = 'ic-rails-huey-toby'
  OAUTH_APPLICATION_REDIRECT_URI = 'urn:ietf:wg:oauth:2.0:oob'

  class << self
    # https://github.com/doorkeeper-gem/doorkeeper/issues/846#issuecomment-230297646
    def generate_access_token(user)
      Doorkeeper::AccessToken.create(
        application_id: generate_application.id,
        resource_owner_id: user.id,
        refresh_token: Doorkeeper::OAuth::Helpers::UniqueToken.generate,
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: Doorkeeper.configuration.default_scopes
      )
    end

    private

    def generate_application
      Doorkeeper::Application.find_or_create_by(name: OAUTH_APPLICATION_NAME,
                                                redirect_uri: OAUTH_APPLICATION_REDIRECT_URI)
    end
  end
end
