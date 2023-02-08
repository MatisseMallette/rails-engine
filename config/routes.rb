Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # TODO: MAJOR REFACTOR: MERGE FIND AND FIND_ALL, WITH FIND BEING FIND#SHOW AND FIND_ALL BEING FIND#INDEX
      namespace :merchants do
        resources :find, only: :index
        resources :find_all, only: :index
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchants/items'
      end
      namespace :items do
        resources :find, only: :index
        resources :find_all, only: :index
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resource :merchant, only: [:show], controller: 'items/merchants'
      end
    end
  end
end
