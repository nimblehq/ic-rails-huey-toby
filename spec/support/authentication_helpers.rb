# frozen_string_literal: true

module Request
  module AuthenticationHelpers
    def post_authenticated_request(user:, endpoint:, params: {})
      application = Fabricate(:application)
      access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)

      headers = {
        Authorization: "Bearer #{access_token.token}"
      }

      post endpoint, headers: headers, params: params
    end

    def get_authenticated_request(user:, endpoint:, params: {})
      application = Fabricate(:application)
      access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)

      headers = {
        Authorization: "Bearer #{access_token.token}"
      }

      get endpoint, headers: headers, params: params
    end
  end
end

RSpec.configure do |config|
  config.include Request::AuthenticationHelpers, type: :request
end
