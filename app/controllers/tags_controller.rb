# frozen_string_literal: true

class TagsController < ApiController
  before_action :authenticate_user!
end
