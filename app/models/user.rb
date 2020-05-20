# frozen_string_literal: true

class User < ApplicationRecord
  has_many :interests, dependent: :destroy
  has_many :activities, through: :interests
end
