# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "rooms#index"
  devise_for :users, controllers: { sessions: 'sessions' }

  resources :room_messages
  resources :rooms

  mount ActionCable.server => '/cable'
  get "static_pages/home"
  get "static_pages/about"
  get "static_pages/contact"

  namespace :manager do
    root "charts#index"

    resources :charts do
      collection do
        get "order_by_month"
        get "order_by_year"
      end
    end
  end
end
