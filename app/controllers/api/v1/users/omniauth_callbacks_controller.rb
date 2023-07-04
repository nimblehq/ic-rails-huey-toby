# frozen_string_literal: true

module Api
  module V1
    module Users
      class OmniauthCallbacksController < Devise::OmniauthCallbacksController
        respond_to :json

        def google_oauth2
          @user = User.from_omniauth(auth)

          render_new_token
        end

        private

        def auth
          @auth ||= request.env['omniauth.auth']
        end

        def render_new_token
          oauth_token = OauthToken.generate_access_token(@user)
          data = OauthTokenSerializer.new(oauth_token).serializable_hash[:data]

          render json: { data: data }, status: :ok
        end
      end
    end
  end
end
