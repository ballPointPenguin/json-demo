# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Interests", type: :request do
  it_behaves_like "jsonapi DELETE#destroy", Interest
  it_behaves_like "jsonapi GET#index", Interest
  it_behaves_like "jsonapi GET#show", Interest
  it_behaves_like "jsonapi PATCH#update",
    Interest, :details, { "item" => "new details" }
  it_behaves_like "jsonapi POST#create", Interest
end
