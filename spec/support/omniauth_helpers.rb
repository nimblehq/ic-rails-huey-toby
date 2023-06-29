# frozen_string_literal: true

# spec/support/omniauth_helper.rb
module Request
  class OmniAuthCallback
    attr_reader :provider

    def initialize(provider)
      OmniAuth.config.test_mode = true
      @provider = provider.to_sym
    end

    def mock(params)
      auth_hash = OmniAuth::AuthHash.new params.update(provider: provider)
      OmniAuth.config.mock_auth[provider] = auth_hash
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = auth_hash
    end
  end
end
