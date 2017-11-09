Rails.application.routes.draw do
  
 
  resources :tasks do
            resources :comments, :only => [:create, :destroy]
  end
  get "home/index"
  get "page/:id" => 'home#page', :as => 'page'
  
  resources :courses
  get 'auth/:provider/callback', to: 'sessions#callback'
  get 'users/logout', to: 'sessions#destroy'
  get 'users/registration', to: 'sessions#registration', as: 'user_registration'
  patch 'users/registration', to: 'sessions#confirmation'
  
  namespace :activity_watcher, path: 'activity-watcher', as: "" do
    get '/', to: 'homes#index', as: 'activity_watcher'
    resources :members
    resources :teams
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 #get "home#index"



    
 end
