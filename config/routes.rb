# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth"

  as :user do
    # Define routes for User within this block.
  end

  jsonapi_resources :activities
  jsonapi_resources :interests
  jsonapi_resources :tags
  jsonapi_resources :users
end
