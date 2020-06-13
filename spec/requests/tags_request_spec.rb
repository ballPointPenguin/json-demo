# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tags", type: :request do
  it_behaves_like "jsonapi DELETE#destroy", Tag
  it_behaves_like "jsonapi GET#index", Tag
  it_behaves_like "jsonapi GET#show", Tag
  it_behaves_like "jsonapi PATCH#update", Tag, :title, "new title"
  it_behaves_like "jsonapi POST#create", Tag
end
