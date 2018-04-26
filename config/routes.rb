Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks, except: :show
  resources :sessions, only: [:new, :create]
  delete "/session" => "sessions#destroy", as: :destroy_session
  
  namespace :admin do
    resources :users, only: [:index, :show]
    resources :tasks, except: :show
    resources :registrations
  end
  root "tasks#index"
end
