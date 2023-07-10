require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper

  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  namespace :api do
    namespace :v1 do
      resources :upload, only: [:create], controller: 'search_results'
      resources :search_results, only: [:index]

      devise_for :users, controllers: {
        sessions: 'api/v1/users/sessions',
        registrations: 'api/v1/users/registrations',
        omniauth_callbacks: 'api/v1/users/omniauth_callbacks',
        confirmations: 'api/v1/users/confirmations'
      }

      root "/health#show"
    end
  end

  root "health#show"
end
