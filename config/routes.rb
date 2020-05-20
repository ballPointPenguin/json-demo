# frozen_string_literal: true

Rails.application.routes.draw do
  resources :activities
  resources :interests
  resources :tags
  resources :users
end
