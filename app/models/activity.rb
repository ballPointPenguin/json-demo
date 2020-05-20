# frozen_string_literal: true

class Activity < ApplicationRecord
  has_many :activity_tags, dependent: :destroy
  has_many :interests, dependent: :destroy
  has_many :tags, through: :activity_tags
  has_many :users, through: :interests

  before_create do
    self.slug = title.parameterize if title && slug.blank?
    self.title = slub.titleize if slug && title.blank?
  end
end
