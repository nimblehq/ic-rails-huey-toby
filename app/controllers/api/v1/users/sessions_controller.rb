# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        include ValidClientConcern

        respond_to :json

        before_action :ensure_valid_client

        def create
          user = User.find_by(email: params[:user][:email])
          valid_provider = user&.provider == User.providers[:email]
          valid_password = user&.valid_password?(params[:user][:password])

          # TODO: Check if user has verified e-mail (#7)
          if valid_provider && valid_password
            render_success(user)
          else
            render_error
          end
        end

        private

        def render_success(user)
          oauth_token = OauthToken.generate_access_token(user)
          token_data = OauthTokenSerializer.new(oauth_token)

          render json: token_data, status: :ok
        end

        def render_error
          # TODO: return error messages in JSON:API format

          message = [I18n.t('devise.failure.invalid', authentication_keys: :email)]

          render json: { errors: message }, status: :unauthorized
        end
      end
    end
  end
end
