# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        include ValidClientConcern

        respond_to :json

        def create
          user = User.find_by(email: user_params[:email])

          if user&.valid_password?(user_params[:password])
            render_success(user)
          else
            render_error([I18n.t('devise.failure.invalid', authentication_keys: :email)])
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

        def render_error(messages)
          # TODO: return error messages in JSON:API format
          render json: { errors: messages }, status: :unauthorized
        end
      end
    end
  end
end
