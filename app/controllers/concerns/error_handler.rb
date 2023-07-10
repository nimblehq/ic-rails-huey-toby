# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  private

  # Render Error Message in json_api format
  # :reek:LongParameterList { max_params: 5 }
  def render_error(detail:, meta: nil, status: :unprocessable_entity, code: nil)
    errors = build_errors(detail: detail, meta: meta, code: code)

    render json: { errors: errors }, status: status
  end

  # :reek:LongParameterList { max_params: 4 }
  def build_errors(detail:, meta: nil, code: nil)
    [
      {
        detail: detail,
        code: code,
        meta: meta
      }.compact_blank!
    ]
  end
end
