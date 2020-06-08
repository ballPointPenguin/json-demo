# frozen_string_literal: true

class TagResource < JSONAPI::Resource
  attributes :slug, :title

  has_many :activity_tags
  has_many :activities
end
