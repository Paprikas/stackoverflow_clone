Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :cancel_vote
    end
  end

  concern :commentable do
    shallow do
      member do
        post :comment
      end
    end
  end

  resources :questions,
            only: [:new, :create, :show, :update, :destroy],
            concerns: [:votable, :commentable] do
    resources :answers,
              only: [:new, :create, :update, :destroy],
              concerns: [:votable, :commentable] do
      member do
        post :accept
      end
    end
  end

  root to: 'questions#index'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
