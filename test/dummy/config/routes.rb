Rails.application.routes.draw do
  resources :users, only: [:index, :show, :edit]
  resources :widgets, only: [:show]
end
