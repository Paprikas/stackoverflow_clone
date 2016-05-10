Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :cancel_vote
    end
  end

  resources :questions,
            only: [:new, :create, :show, :update, :destroy],
            concerns: :votable do
    resources :comments, only: :create, defaults: {commentable: 'questions'}

    resources :answers,
              only: [:new, :create, :update, :destroy],
              concerns: :votable do
      resources :comments, only: :create, defaults: {commentable: 'answers'}
      member do
        post :accept
      end
    end
  end

  root to: 'questions#index'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
