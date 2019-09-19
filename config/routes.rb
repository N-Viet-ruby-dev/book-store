# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "static_pages#home"
  devise_for :users
  get "static_pages/home"
  get "static_pages/about"
  get "static_pages/contact"

  namespace :manager do
    root "charts#index"
  end
end
