# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        include HasDoorkeeperAuthentication

        respond_to :json

        skip_before_action :doorkeeper_authorize!

        def create
          user = User.find_by(email: user_params[:email], provider: User.providers[:email])
          valid_password = user&.valid_password?(user_params[:password])

          if !valid_password
            render_invalid_password_error
          elsif !user.confirmed?
            render_unconfirmed_user_error
          else
            render_success(user)
          end
        end

        private

        def user_params
          params.require(:user).permit(:email, :password)
        end

        def render_success(user)
          oauth_token = OauthToken.generate_access_token(user)
          token_data = OauthTokenSerializer.new(oauth_token)

          render json: token_data, status: :ok
        end

        def render_invalid_password_error
          render_error(
            detail: I18n.t('devise.failure.invalid', authentication_keys: :email),
            status: :unauthorized
          )
        end

        def render_unconfirmed_user_error
          render_error(
            detail: I18n.t('devise.failure.unconfirmed'),
            status: :unauthorized
          )
        end
      end
    end
  end
end
