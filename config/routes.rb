# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "rooms#index"
  devise_for :users
  resources :room_messages
  resources :rooms

  mount ActionCable.server => '/cable'

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
