# frozen_string_literal: true

class InterestsController < ApiController
  before_action :authenticate_user!
end
