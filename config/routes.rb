# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end
      resources :merchants, only: %i[index show] do
        resources :items, only: [:index], controller: 'merchants/items'
      end
      namespace :items do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end
      resources :items, only: %i[index show create update destroy] do
        resource :merchant, only: [:show], controller: 'items/merchants'
      end
    end
  end
end
