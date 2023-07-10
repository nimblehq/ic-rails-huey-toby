# frozen_string_literal: true

module ValidClientConcern
  extend ActiveSupport::Concern

  included do
    before_action :ensure_valid_client
  end

  def ensure_valid_client
    # TODO: return error messages in JSON:API format

    @client_app = Doorkeeper::Application.by_uid_and_secret(params[:client_id], params[:client_secret])

    render json: { errors: I18n.t('doorkeeper.errors.messages.invalid_client') }, status: :forbidden if @client_app.blank?
  end
end
