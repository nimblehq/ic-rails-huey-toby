Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'upload', to: 'upload#create'

      root "/health#show"
    end
  end
  
  root "health#show"
end
