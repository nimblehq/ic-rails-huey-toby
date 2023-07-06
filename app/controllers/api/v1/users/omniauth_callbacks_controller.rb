# frozen_string_literal: true

module Api
  module V1
    module Users
      class OmniauthCallbacksController < Devise::OmniauthCallbacksController
        respond_to :json

        def google_oauth2
          user = User.from_omniauth(auth)

          render_response(user)
        end

        private

        def auth
          @auth ||= request.env['omniauth.auth']
        end

        def render_response(user)
          oauth_token = OauthToken.generate_access_token(user)
          token_data = OauthTokenSerializer.new(oauth_token).serializable_hash[:data]

          message = if user.persisted?
                      I18n.t('activemodel.notices.models.user.sign_in')
                    else
                      I18n.t('activemodel.notices.models.user.sign_up')
                    end

          render json: { data: token_data, meta: { message: message } }, status: :ok
        end
      end
    end
  end
end
