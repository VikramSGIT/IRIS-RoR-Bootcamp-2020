Rails.application.routes.draw do
  root to: 'articles#index'
  resources :articles

  resources :users
  
  resources :sessions, only: [:new, :create, :destroy]

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'newarticle/:id', to: 'application#ajax'
end