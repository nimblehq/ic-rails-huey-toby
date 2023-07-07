# frozen_string_literal: true

module Api
  module V1
    module Users
      class OmniauthCallbacksController < Devise::OmniauthCallbacksController
        rescue_from Exception, with: :render_error

        respond_to :json

        def google_oauth2
          user = User.from_omniauth(auth)

          render_success(user)
        end

        private

        def auth
          @auth ||= request.env['omniauth.auth']
        end

        def render_success(user)
          oauth_token = OauthToken.generate_access_token(user)
          token_data = OauthTokenSerializer.new(oauth_token).serializable_hash[:data]

          message = if user.persisted?
                      I18n.t('activemodel.notices.models.user.sign_in')
                    else
                      I18n.t('activemodel.notices.models.user.sign_up')
                    end

          render json: { data: token_data, meta: { message: message } }, status: :ok
        end

        def render_error(exception)
          render json: { error: exception.message }, status: :internal_server_error
        end
      end
    end
  end
end
