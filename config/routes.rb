# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "rooms#index"
  devise_for :users

  namespace :manager do
    root "charts#index"
  end

  resources :room_messages
  resources :rooms

  mount ActionCable.server => '/cable'
end
