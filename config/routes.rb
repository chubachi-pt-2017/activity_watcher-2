Rails.application.routes.draw do
  
  get 'auth/:provider/callback', to: 'sessions#callback'
  get 'users/logout', to: 'sessions#destroy'
  get 'users/registration', to: 'sessions#registration', as: 'user_registration'
  patch 'users/registration', to: 'sessions#confirmation'
  get 'users/confirmation', to: 'sessions#email_confirmation', as: 'users_email_confirmation'
  get 'users/registration/thanks', to: 'sessions#thanks', as: 'users_thanks'
  get 'users/email_unconfirmed', to: 'sessions#email_unconfirmed', as: 'users_email_unconfirmed'
  
  namespace :activity_watcher, path: 'activity-watcher', as: "" do
    get '/', to: 'homes#index', as: 'activity_watcher'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
end
