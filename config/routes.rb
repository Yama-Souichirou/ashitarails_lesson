class AuthenticatedConstraint
  def matches?(request)
    user =  User.find_by(remember_token: Digest::SHA256.hexdigest(request.cookies["user_remember_token"].to_s))
    user.present? && user.admin?
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  constraints AuthenticatedConstraint.new do
    root to: 'admin/users#index'
  end
  resources :tasks, except: :show
  resources :sessions, only: [:new, :create]
  resources :labels, only: [:index]
  resources :users, only: [:show, :update]
  delete "/session" => "sessions#destroy", as: :destroy_session
  
  namespace :admin do
    resources :users, only: [:index, :show]
    resources :tasks, except: :show
    resources :registrations
    resources :labels, only: [:index, :new, :create, :destroy]
  end
  root "tasks#index"
end
