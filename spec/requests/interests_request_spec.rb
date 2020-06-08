# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Interests", type: :request do
  it_behaves_like "jsonapi request",
    Interest, :details, { "item" => "new details" }
end
