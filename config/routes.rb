Rails.application.routes.draw do
  root to: 'messages#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :messages, only: [:index, :create]
    end
  end

  resources :messages, only: [:index]
end
