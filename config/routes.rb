Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end

  resources :events do
    resources :reviews
    resources :bookmarks, only: [:create]
  end

  resources :lists, only: [:create]

  resources :personalities, only: [:new, :create, :edit, :update]

  resources :bookmarks, only: [:index, :destroy]
end
