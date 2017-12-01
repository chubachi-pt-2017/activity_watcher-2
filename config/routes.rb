Rails.application.routes.draw do
  
  get 'auth/:provider/callback', to: 'sessions#callback'
  get 'users/logout', to: 'sessions#destroy'
  get 'users/registration', to: 'sessions#register', as: 'user_register'
  patch 'users/registration', to: 'sessions#confirm'
  get 'users/confirmation', to: 'sessions#confirm_email', as: 'users_confirm_email'
  get 'users/registration/thanks', to: 'sessions#thanks', as: 'users_thanks'
  get 'users/email_unconfirmed', to: 'sessions#inform_email_unconfirmed', as: 'users_email_unconfirmed'
  get 'users/email_resend', to: 'sessions#resend', as: 'users_email_resend'
  
  namespace :activity_watcher, path: 'activity-watcher', as: "" do
    get '/', to: 'homes#index', as: 'activity_watcher'
    
    resources :teams 
    resources :courses do
      resources :tasks
    end
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  
end
