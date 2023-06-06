Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end

  resources :event do
    resources :reviews
  end

  resources :questionnaire, only: [:new, :create, :destroy]

  resources :bookmarks, only: [:new, :index, :create, :destroy]
end
