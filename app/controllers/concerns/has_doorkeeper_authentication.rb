# frozen_string_literal: true

module HasDoorkeeperAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :doorkeeper_authorize!
    before_action :ensure_valid_client
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

  def ensure_valid_client
    # TODO: return error messages in JSON:API format

    client_app = Doorkeeper::Application.by_uid_and_secret(params[:client_id], params[:client_secret])

    render json: { errors: I18n.t('doorkeeper.errors.messages.invalid_client') }, status: :forbidden if client_app.blank?
  end
end
