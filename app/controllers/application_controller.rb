# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Localization
  include ErrorHandleable

  rescue_from IcRailsHueyToby::Errors::RecordNotFound do |exception|
    render_error(detail: exception.message, status: :not_found)
  end
end
