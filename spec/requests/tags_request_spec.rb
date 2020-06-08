# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tags", type: :request do
  it_behaves_like "jsonapi request", Tag, :title, "new title"
end
