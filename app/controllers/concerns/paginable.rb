# frozen_string_literal: true

module Paginable
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

    def meta_from_pagy(pagy)
      {
        page: pagy.page,
        pages: pagy.pages,
        page_size: pagy.items,
        records: pagy.count
      }
    end
  end
end
