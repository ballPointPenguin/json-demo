# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Activities", type: :request do
  it_behaves_like "jsonapi request", Activity, :title, "new title"
end
