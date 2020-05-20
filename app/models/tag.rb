# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :activity_tags, dependent: :destroy
  has_many :activities, through: :activity_tags

  before_create do
    self.slug = title.parameterize if title && slug.blank?
    self.title = slug.titleize if slug && title.blank?
  end
end
