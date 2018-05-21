Rails.application.routes.draw do
  resources :tasks do
    get :calendar, on: :collection
  end
  resources :sessions, only: [:new, :create]
  resources :labels, only: [:index]
  resources :users, only: [:show, :update]
  resources :groups do
    resources :users do
      resource :group_users, only: :destroy
    end
  end
  delete "/session" => "sessions#destroy", as: :destroy_session
  
  namespace :admin do
    root 'users#index'
    resources :users, only: [:index, :show]
    resources :tasks
    resources :registrations
    resources :labels, only: [:index, :new, :create, :destroy]
  end
  root "tasks#index"
  
end
