Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :users, only: [:index, :show] do
    resources :chats, only: [:create]
  end

  resources :chats, only: [:show, :index] do
    resources :messages, only: [:create]
  end

end
