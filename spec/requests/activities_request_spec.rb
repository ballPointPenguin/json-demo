# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Activities", type: :request do
  it_behaves_like "jsonapi DELETE#destroy", Activity
  it_behaves_like "jsonapi GET#index", Activity
  it_behaves_like "jsonapi GET#show", Activity
  it_behaves_like "jsonapi PATCH#update", Activity, :title, "new title"
  it_behaves_like "jsonapi POST#create", Activity
end
