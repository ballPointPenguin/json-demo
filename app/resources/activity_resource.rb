# frozen_string_literal: true

class ActivityResource < JSONAPI::Resource
  attributes :slug, :title

  has_many :activity_tags
  has_many :interests
  has_many :tags
  has_many :users
end
