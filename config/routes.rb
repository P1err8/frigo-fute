Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # resources :users, only: [:index, :show] do
  #   resources :recipes, only: [:create, :new]
  # end

  resources :recipes, only: [:show, :index, :create, :new] do
    resources :messages, only: [:create]
  end

end
