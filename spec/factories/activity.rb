# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    title { Faker::Lorem.sentence }
  end
end
