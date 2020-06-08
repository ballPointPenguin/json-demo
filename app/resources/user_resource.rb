# frozen_string_literal: true

class UserResource < JSONAPI::Resource
  attributes :is_admin, :age, :city, :country, :email, :gender, :links, :name, :state

  has_many :interests
  has_many :activities

  key_type :uuid
end
