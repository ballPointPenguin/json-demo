# frozen_string_literal: true

class ApiController < ApplicationController
  include JSONAPI::Utils
  # check_authorization

  rescue_from ActiveRecord::RecordNotFound, with: :jsonapi_render_not_found

  rescue_from CanCan::AccessDenied do |exception|
    errors = [JSONAPI::Error.new(
      code: 403,
      status: :forbidden,
      title: "Forbidden",
      detail: "You are not authorized to access this resource."
    )]

    jsonapi_render_errors(json: errors)
  end
end
