# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        before_action :ensure_valid_client

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
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end

        def ensure_valid_client
          @client_app = Doorkeeper::Application.by_uid_and_secret(params[:client_id], params[:client_secret])

          render json: { errors: I18n.t('doorkeeper.errors.messages.invalid_client') }, status: :forbidden if @client_app.blank?
        end
      end
    end
  end
end
