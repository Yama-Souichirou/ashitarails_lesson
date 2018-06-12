Rails.application.routes.draw do
  namespace :api do
    resources :tasks, only: [:index, :update, :destroy]
  end
  
  namespace :admin do
    root 'tasks#index'
    resources :users, only: [:index, :show]
    resources :tasks
    resources :registrations
    resources :labels, only: [:index, :new, :create, :destroy]
    resources :groups do
      resources :users do
        resource :group_users, only: :destroy
      end
    end
  end

  resources :tasks do
    get :calendar, on: :collection
  end
  resources :sessions, only: [:new, :create]
  resources :labels, only: [:index]
  resources :users, only: [:show, :update, :edit]
  resources :groups do
    resources :users do
      resource :group_users, only: :destroy
    end
  end
  delete "/session" => "sessions#destroy", as: :destroy_session
  root "tasks#index"
end
