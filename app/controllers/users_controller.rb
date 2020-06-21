# frozen_string_literal: true

class UsersController < ApiController
  before_action :authenticate_user!
  # load_and_authorize_resource

  # GET /users
  def index
    users = User.accessible_by(current_ability)
    jsonapi_render json: users
  end
end
