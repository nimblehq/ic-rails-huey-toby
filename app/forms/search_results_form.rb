# frozen_string_literal: true

class SearchResultsForm
  include Pagy::Backend

  def initialize(user_id:)
    @user_id = user_id
    @search_results = SearchResult.order(:id).where(user_id: @user_id)
  end

  def paginated_results(params:)
    pagination_params = pagination_params(params: params)
    @pagy, @search_results_paginated = pagy(@search_results, pagination_params)

    {
      results: @search_results_paginated,
      pagy: @pagy
    }
  end

  def pagination_params(params:)
    {
      page: params.dig(:page, :number) || Pagy::DEFAULT[:page],
      items: params.dig(:page, :size) || Pagy::DEFAULT[:items]

    }
  end
end
