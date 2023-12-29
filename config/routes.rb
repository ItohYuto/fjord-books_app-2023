Rails.application.routes.draw do
  get 'comments/show'
  resources :reports do
    scope module: :reports do
      resources :comments, only: :create
    end
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books do
    scope module: :books do
      resources :comments, only: :create
    end
  end
  resources :users, only: %i(index show)
  resources :comments, only: :destroy
end
