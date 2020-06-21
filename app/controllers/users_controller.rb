# frozen_string_literal: true

class UsersController < ApiController
  before_action :authenticate_user!
end
