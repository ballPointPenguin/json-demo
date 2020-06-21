# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Activities", type: :request do
  it_behaves_like "jsonapi DELETE#destroy auth", Activity
  it_behaves_like "jsonapi GET#index auth", Activity
  it_behaves_like "jsonapi GET#show auth", Activity
  it_behaves_like "jsonapi PATCH#update auth", Activity, :title, "new title"
  it_behaves_like "jsonapi POST#create auth", Activity
end
