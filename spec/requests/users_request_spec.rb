# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  it_behaves_like "jsonapi DELETE#destroy", User
  it_behaves_like "jsonapi GET#index", User
  it_behaves_like "jsonapi GET#show", User
  it_behaves_like "jsonapi PATCH#update", User, :name, "new name"
  # it_behaves_like "jsonapi POST#create", User
end
