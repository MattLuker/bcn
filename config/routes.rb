Rails.application.routes.draw do

  get 'home/index'
  get 'home', to: 'home#home'
  get 'who_we_are', to: 'home#who_we_are'
  get 'calendar', to: 'home#calendar'

  resources :communities do
    patch 'users', to: 'communities#add_user'
    delete 'users', to: 'communities#remove_user'
    get :podcast, to: 'communities#podcast'
  end

  resources :posts do
    resources :locations
    resources :comments, only: [:create]
    resources :subscribers, only: [:create, :destroy]
    delete 'community', to: 'posts#remove_community'
    get :autocomplete_community_name, on: :collection
    get :get_og_data, on: :collection
  end

  resources :comments, only: [:update, :destroy, :show] do
    resources :replies, only: [:create]
    resources :comments, only: [:create, :update, :destroy]
  end

  resources :searches, only: [:index]

  get '/login' => 'user_sessions#new', as: :login
  get '/logout' => 'user_sessions#destroy', as: :logout
  resources :user_sessions, only: [:create, :new]
  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]
  get :send_merge, to: 'users#send_merge_email'
  get :merge_user, to: 'users#merge_user'

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

  get 'auth/facebook', as: 'auth_provider'
  get 'auth/facebook/callback', to: 'user_sessions#facebook_login'
  get 'auth/twitter', as: 'twitter_auth_provider'
  get 'auth/twitter/callback', to: 'user_sessions#twitter_login'
  get 'auth/google_oauth2', as: 'google_auth_provider'
  get 'auth/google_oauth2/callback', to: 'user_sessions#google_login'
  get 'auth/failure', to: 'user_sessions#auth_failure'


  root 'home#index'

end
