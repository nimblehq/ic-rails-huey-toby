# frozen_string_literal: true

module DoorkeeperAuthentication
  extend ActiveSupport::Concern
  include ErrorHandler

  included do
    before_action :doorkeeper_authorize!
  end

  private

  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # :reek:FeatureEnvy
  def doorkeeper_unauthorized_render_options(error: nil)
    return unless error

    {
      json: {
        errors: build_errors(detail: error.description, code: error.name)
      }
    }
  end
end
