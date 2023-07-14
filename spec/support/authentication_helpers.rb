# frozen_string_literal: true

module Request
  module AuthenticationHelpers
    def create_authorization_header(user:)
      application = Fabricate(:application)
      access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)

      {
        Authorization: "Bearer #{access_token.token}"
      }
    end
  end
end

RSpec.configure do |config|
  config.include Request::AuthenticationHelpers, type: :request
end
