# frozen_string_literal: true

module Api
  module V1
    module Users
      class OmniauthCallbacksController < Devise::OmniauthCallbacksController
        respond_to :json

        def google_oauth2
          user = User.from_omniauth(auth)
          user.errors.empty? ? render_success(user) : render_error(user)
        end

        private

        def auth
          @auth ||= request.env['omniauth.auth']
        end

        def render_success(user)
          oauth_token = OauthToken.generate_access_token(user)
          token_data = OauthTokenSerializer.new(oauth_token).serializable_hash[:data]

          render json: { data: token_data }, status: :ok
        end

        def render_error(user)
          render json: { errors: user.errors.full_messages }, status: :internal_server_error
        end
      end
    end
  end
end
