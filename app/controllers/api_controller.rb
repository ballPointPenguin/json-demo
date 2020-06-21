# frozen_string_literal: true

class ApiController < ApplicationController
  include JSONAPI::Utils
  # check_authorization

  rescue_from ActiveRecord::RecordNotFound, with: :jsonapi_render_not_found
end
