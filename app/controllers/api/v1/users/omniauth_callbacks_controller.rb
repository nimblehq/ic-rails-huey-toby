# frozen_string_literal: true

module Api
  module V1
    module Users
      class OmniauthCallbacksController < Devise::OmniauthCallbacksController
        respond_to :json
        def google_oauth2
          @user = User.from_omniauth(auth)

          if @user.persisted?
            render_success
          else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def auth
          @auth ||= request.env['omniauth.auth']
        end

        def render_success
          # TODO: Return JWT token
          render json: { success: true }
        end
      end
    end
  end
end
