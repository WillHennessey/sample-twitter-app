Rails.application.routes.draw do

  root 'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/about', to: 'static_pages#about', via: 'get'
  match 'help', to: 'static_pages#help', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  resources :sessions, only: [:new, :create, :destroy]
  resources :posts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :comments
  resources :users
  resources :users do
    member do
      get :following, :followers
    end
  end
  get 'mentions', to: 'users#mentions'

end
