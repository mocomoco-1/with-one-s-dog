Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  root "tops#index"
  resources :users, only: [ :show, :edit, :update ] do
    member do
      post "follow", to: "relationships#create"
      delete "unfollow", to: "relationships#destroy"
      get :following
      get :followers
    end
    resources :dog_profiles, only: [ :show, :new, :create, :edit, :update, :destroy ]
  end
  get "/mypage", to: "users#mypage"
  resources :consultations, only: [ :index, :new, :create, :show, :edit, :update, :destroy ] do
    collection do
      get :my_consultations
    end
    resources :comments, only: [ :create, :destroy ], shallow: true do
      resource :like, only: [ :create ]
    end
    resources :reactions, only: [ :create ]
  end
  resources :chat_rooms, only: [ :index, :show, :create ] do
    resources :chat_messages, only: [ :create ]
  end
  resources :diaries, only: [ :index, :show, :new, :create, :edit, :update, :destroy ] do
    collection do
      get :my_diaries
    end
    resources :comments, only: [ :create, :destroy ], shallow: true do
      resource :like, only: [ :create ]
    end
    resources :reactions, only: [ :create ]
  end
  resources :ai_consultations, only: [ :new, :create ] # :index, :showを付け足す
  namespace :dog_diagnosis do
    get "diagnoses/index"
    get "questions", to: "diagnoses#questions"
    post "diagnoses", to: "diagnoses#result"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
