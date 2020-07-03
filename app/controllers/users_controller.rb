# frozen_string_literal: true

class UsersController < ApiController
  before_action :authenticate_user!
  # load_and_authorize_resource

  # GET /users
  def index
    users = User.accessible_by(current_ability)
    jsonapi_render json: users
  end

  # GET /users/:id
  def show
    user = User.find(params[:id])
    authorize! :show, user
    jsonapi_render json: user
  end
end
