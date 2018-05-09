Rails.application.routes.draw do
  resources :tasks, except: :show
  resources :sessions, only: [:new, :create]
  resources :labels, only: [:index]
  resources :users, only: [:show, :update]
  delete "/session" => "sessions#destroy", as: :destroy_session
  
  namespace :admin do
    root 'users#index'
    resources :users, only: [:index, :show]
    resources :tasks, except: :show
    resources :registrations
    resources :labels, only: [:index, :new, :create, :destroy]
  end
  root "tasks#index"
end
