# frozen_string_literal: true

Rails.application.routes.draw do
  jsonapi_resources :activities
  jsonapi_resources :interests
  jsonapi_resources :tags
  jsonapi_resources :users
end
