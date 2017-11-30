Rails.application.routes.draw do
  
  resources :teams
 
  
  get 'auth/:provider/callback', to: 'sessions#callback'
  get 'users/logout', to: 'sessions#destroy'
  get 'users/registration', to: 'sessions#registration', as: 'user_registration'
  patch 'users/registration', to: 'sessions#confirmation'
  
  namespace :activity_watcher, path: 'activity-watcher', as: "" do
    get '/', to: 'homes#index', as: 'activity_watcher'
     #get "/activity-watcher/teams"
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
    #root 'teams#index'
  
end
