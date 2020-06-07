# frozen_string_literal: true

class User < ApplicationRecord
  has_many :interests, dependent: :destroy
  has_many :activities, through: :interests

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, presence: true, uniqueness: true
end
