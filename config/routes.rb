Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :cancel_vote
    end
  end

  post 'comment/:commentable/:commentable_id/', to: 'comments#create', as: :comment

  resources :questions,
            only: [:new, :create, :show, :update, :destroy],
            concerns: :votable do
    resources :answers,
              only: [:new, :create, :update, :destroy],
              concerns: :votable do
      member do
        post :accept
      end
    end
  end

  root to: 'questions#index'
end
