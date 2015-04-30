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

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
