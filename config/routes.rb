Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :upload, only: [:create], controller: 'search_results'

      root "/health#show"
    end
  end
  
  root "health#show"
end
