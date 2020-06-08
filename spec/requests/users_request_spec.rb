# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  it_behaves_like "jsonapi request", User, :name, "new name"
end
