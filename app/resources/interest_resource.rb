# frozen_string_literal: true

class InterestResource < JSONAPI::Resource
  attributes :details, :user_id

  has_one :activity
  has_one :user
end
