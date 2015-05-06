Rails.application.routes.draw do
  get '/login' => 'user_sessions#new', as: :login
  get '/logout' => 'user_sessions#destroy', as: :logout
  get 'home/index'
  get 'home', to: 'home#home'
  get 'who_we_are', to: 'home#who_we_are'
  get 'calendar', to: 'home#calendar'

  resources :communities do
    patch 'users', to: 'communities#add_user'
    delete 'users', to: 'communities#remove_user'
  end

  resources :user_sessions, only: [:create, :new]
  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]

  get 'locations', to: 'locations#show'

  namespace :api do
    resources :posts do
      resources :locations, only: [:create, :update, :destroy]
      resources :communities, only: [:create, :update, :destroy]
    end

    resources :communities do
      resources :posts, only: [:create, :update, :destroy]
      patch 'users', to: 'communities#add_user'
      delete 'users', to: 'communities#remove_user'
    end

    resources :locations, only: [:show, :create, :update, :destroy] do
      resources :posts, only: [:create, :update, :destroy]
    end

    resources :users do
      resources :posts, only: [:create, :update, :destroy]
    end
  end

  resources :posts do 
    resources :locations
    delete 'community', to: 'posts#remove_community'
  end

  get 'auth/facebook', as: 'auth_provider'
  get 'auth/facebook/callback', to: 'user_sessions#facebook_login'

  root 'home#index'

end
