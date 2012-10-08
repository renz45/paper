Paper::Application.routes.draw do
  devise_for :users

  root to: 'posts#index'

  resources :posts, only: [:show]

  namespace :admin do
    root to: 'posts#index'
    resources :posts
  end
end
