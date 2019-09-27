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
        get "revenue_in_month"
        get "revenue_in_year"
        get "order_details_by_date"
        get "compare_between_year"
        get "compare_year"
        get "statistics_by_the_year"
      end
    end
  end
end
