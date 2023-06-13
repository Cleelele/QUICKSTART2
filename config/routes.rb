Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end

  resources :events do
    resources :reviews, except: [:destroy, :index]
    resources :bookmarks, only: [:create]
  end

  resources :reviews, only: [:destroy, :index]

  resources :lists, only: [:create]

  resources :personalities, only: [:new, :create, :edit, :update]

  resources :bookmarks, only: [:index, :destroy]
end
