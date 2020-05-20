# frozen_string_literal: true

class ActivityTag < ApplicationRecord
  belongs_to :activity
  belongs_to :tag
end
