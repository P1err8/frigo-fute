Rails.application.routes.draw do
  get 'recipes/new'
  devise_for :users
  root to: "pages#home"

  resources :users, only: [:index, :show] do
    resources :recipes, only: [:create, :new]
  end

  resources :recipes, only: [:show, :index] do
    resources :messages, only: [:create]
  end

end
