Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}

  get '/finish_signup' => 'registrations#finish_signup', as: :finish_signup
  patch '/finish_signup' => 'registrations#send_confirmation_email', as: :send_confirmation_email

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

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :all, on: :collection
      end
    end
  end

  root to: 'questions#index'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
