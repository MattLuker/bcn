Rails.application.routes.draw do

  get 'home/index'
  get 'home', to: 'home#home'
  get 'help', to: 'home#help'
  get 'contact', to: 'home#contact'
  post 'send_contact', to: 'home#send_contact'
  get 'about', to: 'home#about'
  get 'calendar', to: 'home#calendar'

  resources :communities do
    patch 'organizations', to: 'communities#add_member'
    delete 'organizations', to: 'communities#remove_member', as: 'remove_organization'
    get :podcast, to: 'communities#podcast'
    resources :subscribers, only: [:create, :destroy]
  end

  resources :organizations do
    patch 'users', to: 'organizations#add_user'
    delete 'users', to: 'organizations#remove_user'
    resources :roles, only: [:update]
    get :podcast, to: 'organizations#podcast'
    resources :subscribers, only: [:create, :destroy]
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
    resources :comments, only: [:create, :update, :destroy]
  end

  resources :searches, only: [:index]

  #resources :facebook_subscriptions, only: [:index, :create]
  get '/facebook_subscriptions', to: 'facebook_subscriptions#index', as: 'facebook_subscriptions'
  post '/facebook_subscriptions/', to: 'facebook_subscriptions#create'
  resources :badges

  resources :photos, only: [:new, :create]

  get '/login' => 'user_sessions#new', as: :login
  get '/logout' => 'user_sessions#destroy', as: :logout
  resources :user_sessions, only: [:create, :new]
  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]
  get :send_merge, to: 'users#send_merge_email'
  get :merge_user, to: 'users#merge_user'
  put '/add_admin/:user_id', to: 'users#add_admin', as: 'add_admin'
  delete '/remove_admin/:user_id', to: 'users#remove_admin', as: 'remove_admin'


  get 'locations', to: 'locations#show'

  namespace :api do
    resources :posts do
      resources :locations, only: [:create, :update, :destroy]
      resources :communities, only: [:create, :update, :destroy]
      resources :subscribers, only: [:create, :destroy]
      resources :comments, only: [:create]
    end
    get 'today', to: 'posts#today'
    get 'tomorrow', to: 'posts#tomorrow'
    get 'next_week', to: 'posts#next_week'

    resources :comments, only: [:update, :destroy, :show] do
      resources :comments, only: [:create, :update, :destroy]
    end

    resources :communities do
      resources :posts, only: [:create, :update, :destroy]
      resources :locations, only: [:create, :update]
      patch 'organizations', to: 'communities#add_member'
      delete 'organizations', to: 'communities#remove_member', as: 'remove_organization'
      resources :subscribers, only: [:create, :destroy]
    end

    resources :organizations do
      resources :posts, only: [:create, :update, :destroy]
      resources :locations, only: [:create, :update]
      patch 'users', to: 'organizations#add_user'
      delete 'users', to: 'organizations#remove_user'
      resources :subscribers, only: [:create, :destroy]
    end

    resources :locations, only: [:show, :create, :update, :destroy] do
      resources :posts, only: [:create, :update, :destroy]
    end

    resources :users do
      resources :posts, only: [:create, :update, :destroy]
    end

    resources :searches, only: [:index]
    resources :badges, only: [:index, :show]
  end

  get 'auth/facebook', as: 'auth_provider'
  get 'auth/facebook/callback', to: 'user_sessions#facebook_login'
  get 'auth/twitter', as: 'twitter_auth_provider'
  get 'auth/twitter/callback', to: 'user_sessions#twitter_login'
  get 'auth/google_oauth2', as: 'google_auth_provider'
  get 'auth/google_oauth2/callback', to: 'user_sessions#google_login'
  get 'auth/failure', to: 'user_sessions#auth_failure'


  root 'home#home'

  require 'sidekiq/web'
  require 'admin_constraint'
  mount Sidekiq::Web => '/kiq', :constraints => AdminConstraint.new
  # constraints lambda {|request| AuthConstraint.admin?(request) } do
  #   mount Sidekiq::Web => '/admin/kiq'
  # end

end
