# frozen_string_literal: true

class ActivityTagResource < JSONAPI::Resource
  has_one :activity
  has_one :tag
end
