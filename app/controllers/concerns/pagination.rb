# frozen_string_literal: true

module Pagination
  extend ActiveSupport::Concern

  include Pagy::Backend

  included do
    def paginated_resources_for(resources, **options)
      pagy resources, pagination_params.merge(options)
    end

    def pagination_params
      {
        page: params.dig(:page, :number),
        items: params.dig(:page, :size)
      }
    end
  end
end
