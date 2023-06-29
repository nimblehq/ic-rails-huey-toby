# frozen_string_literal: true

module Api
  module V1
    module Users
      class OmniauthCallbacksController < Devise::OmniauthCallbacksController
        respond_to :json
        def google_oauth2
          @user = User.from_omniauth(auth)

          # TODO: Return JWT token on both success and error
          if @user.persisted?
            render_success
          else
            render_error
          end
        end

        private

        def auth
          @auth ||= request.env['omniauth.auth']
        end

        def render_success
          render json: { success: true }
        end

        def render_error
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
