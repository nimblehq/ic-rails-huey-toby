# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Localization
  include ErrorHandleable

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found(exception)
    message = if exception.model == 'SearchResult'
                I18n.t('activemodel.errors.models.search_result.not_found')
              else
                exception.message
              end

    render_error(detail: message, status: :not_found)
  end
end
