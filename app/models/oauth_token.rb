# frozen_string_literal: true

class OauthToken < ApplicationRecord
  class << self
    def generate_access_token(user)
      Doorkeeper::AccessToken.create(
        application_id: generate_application.id,
        resource_owner_id: user.id,
        refresh_token: Doorkeeper::OAuth::Helpers::UniqueToken.generate,
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: ''
      )
    end

    private

    # FIXME: Check if this is the right way to generate an application
    def generate_application
      @application = Doorkeeper::Application.find_or_create_by(name: 'ic-rails-huey-toby',
                                                               redirect_uri: 'urn:ietf:wg:oauth:2.0:oob', scopes: %w[read write])
    end
  end
end
