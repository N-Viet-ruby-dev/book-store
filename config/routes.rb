# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "books#home"

  devise_for :users

  resources :room_messages
  resources :rooms
  resources :books, only: [:index, :show]
  resources :orders, only: [:show, :new, :create]
  resources :carts, only: :update

  mount ActionCable.server => '/cable'

  namespace :manager do
    root "charts#index"

    resources :charts, only: :index do
      collection do
        get "revenue_in_month"
        get "revenue_in_year"
        get "select_to_year"
        get "compare_between_year"
      end
    end

    resources :chart_books, only: :index do
      collection do
        get "best_selling_books"
        get "best_selling_books_in_month"
        get "book_has_biggest_revenue"
        get "book_has_biggest_revenue_in_month"
      end
    end
  end

  post "/add_book", to: "carts#add_book"
end
