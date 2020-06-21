# frozen_string_literal: true

class ActivitiesController < ApiController
  before_action :authenticate_user!
end
