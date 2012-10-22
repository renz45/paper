Paper::Application.routes.draw do
  devise_for :users

  root to: 'posts#index'

  resources :posts, only: [:index, :show]

  namespace :admin do
    root to: 'posts#index'
    resources :posts do
      post :render_preview, on: :collection
    end
  end
end
