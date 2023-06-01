Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :upload, only: [:create], controller: 'search_results'

      root "/health#show"

      resources :search_result, only: [:index]
    end
  end

  root "health#show"
end
