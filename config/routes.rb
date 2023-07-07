require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper

  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  namespace :api do
    namespace :v1 do
      resources :upload, only: [:create], controller: 'search_results'

      devise_for :users, controllers: {
        omniauth_callbacks: 'api/v1/users/omniauth_callbacks'
      }

      root "/health#show"
    end
  end

  root "health#show"
end
