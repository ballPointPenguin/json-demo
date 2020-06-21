# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Interests", type: :request do
  it_behaves_like "jsonapi DELETE#destroy auth", Interest
  it_behaves_like "jsonapi GET#index auth", Interest
  it_behaves_like "jsonapi GET#show auth", Interest
  it_behaves_like "jsonapi PATCH#update auth",
    Interest, :details, { "item" => "new details" }
  it_behaves_like "jsonapi POST#create auth", Interest
end
