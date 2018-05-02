Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks, except: :show
  resources :sessions, only: [:new, :create]
  resources :labels, only: [:index]
  resources :users, only: :show
  delete "/session" => "sessions#destroy", as: :destroy_session
  
  namespace :admin do
    resources :users, only: [:index, :show]
    resources :tasks, except: :show
    resources :registrations
    resources :labels, only: [:index, :new, :create, :destroy]
  end
  root "tasks#index"
end
