Rails.application.routes.draw do
  resources :racers
  root 'racers#index'
end
