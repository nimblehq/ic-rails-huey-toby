# frozen_string_literal: true

module Api
  module V1
    module Users
      class ConfirmationsController < Devise::ConfirmationsController
        include ActionController::Flash

        def after_confirmation_path_for(_resource_name, _resource)
          root_path
        end
      end
    end
  end
end
