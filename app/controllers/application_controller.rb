# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Localization
  include ErrorHandleable

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found(exception)
    model_name = exception.model.constantize.model_name.human
    message = I18n.t('activerecord.errors.not_found', model_name: model_name)

    render_error(detail: message, status: :not_found)
  end
end
