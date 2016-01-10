Rails.application.routes.draw do

  root 'todo_lists#index'


  get "/login" => "sessions#new", as: "login"
  delete "/logout" => "sessions#destroy", as: "logout"

  resources :sessions, only: [:new, :create, :destroy]

  resources :todo_lists do
    resources :todo_items
  end

end
