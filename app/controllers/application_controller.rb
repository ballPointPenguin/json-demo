# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include JSONAPI::Utils

  rescue_from ActiveRecord::RecordNotFound, with: :jsonapi_render_not_found
end
