Rails.application.routes.draw do
  #get 'photos/show'
  root 'places#index'
  resources :places, only: [:index, :show]
  get 'photos/:id/show', to: 'photos#show', as: 'photos_show'
end
