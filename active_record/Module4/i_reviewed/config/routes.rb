Rails.application.routes.draw do
  root to: "books#index"

  resources :books do
    resources :notes , only: [:create, :destroy]
  end
  resources :sessions, only: [:new, :create, :destroy]
  
end
