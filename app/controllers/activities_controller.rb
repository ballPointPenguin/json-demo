# frozen_string_literal: true

class ActivitiesController < ApplicationController
  def index
    activities = Activity.all
    jsonapi_render json: activities
  end
end
