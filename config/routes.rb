# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "books#home"

  devise_for :users

  resources :room_messages
  resources :rooms
  resources :books, only: [:index, :show]
  resources :orders, only: [:new, :create]
  resources :carts, only: :update

  mount ActionCable.server => '/cable'

  namespace :manager do
    root "charts#index"

    resources :charts do
      collection do
        get "revenue_in_month"
        get "revenue_in_year"
        get "select_to_year"
        get "compare_between_year"
      end
    end
  end

  post "/add_book", to: "carts#add_book"
end
