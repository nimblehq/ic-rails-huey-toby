# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        include HasDoorkeeperAuthentication

        respond_to :json

        skip_before_action :doorkeeper_authorize!

        def create
          user = User.from_email(user_params[:email], user_params[:password])

          if user.errors.empty?
            render_success(user)
          else
            render_error(user)
          end
        end

        private

        def user_params
          params.require(:user).permit(:email, :password)
        end

        def render_success(user)
          success_message = I18n.t('activemodel.notices.models.user.create')
          user_data = UserSerializer.new(user, meta: { message: success_message })

          render json: user_data, status: :created
        end

        def render_error(user)
          # TODO: return error messages in JSON:API format

          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
