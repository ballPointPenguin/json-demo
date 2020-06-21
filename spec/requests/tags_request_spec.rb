# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tags", type: :request do
  it_behaves_like "jsonapi DELETE#destroy auth", Tag
  it_behaves_like "jsonapi GET#index auth", Tag
  it_behaves_like "jsonapi GET#show auth", Tag
  it_behaves_like "jsonapi PATCH#update auth", Tag, :title, "new title"
  it_behaves_like "jsonapi POST#create auth", Tag
end
