Rails.application.routes.draw do
  resources :users, only: [:show, :edit]
  resources :widgets, only: [:show]
end
