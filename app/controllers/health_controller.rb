# frozen_string_literal: true

class HealthController < ApplicationController
  rescue_from Exception, with: :render_down

  def show
    render_up
  end

  private

  def render_up
    respond_to do |format|
      format.html { render html: html_status('green'), status: :ok }
      format.json { render json: { message: 'OK' }, status: :ok }
    end
  end

  def render_down(exception)
    respond_to do |format|
      format.html { render html: html_status('red'), status: :internal_server_error }
      format.json { render json: { error: exception.message }, status: :internal_server_error }
    end
  end

  # rubocop:disable Rails/OutputSafety
  def html_status(color)
    %(<html><body style="background-color: #{color}"></body></html>).html_safe
  end
  # rubocop:enable Rails/OutputSafety
end
