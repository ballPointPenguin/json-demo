# frozen_string_literal: true

FactoryBot.define do
  factory :interest do
    transient do
      done { Faker::Boolean.boolean }
      has_comment { Faker::Boolean.boolean }
    end

    activity
    user

    details { {
      done: "#{done ? 'yes' : 'no'}",
      desire: "#{Faker::Number.within(range: 0..5) unless done}",
      pleasure: "#{Faker::Number.within(range: 0..5) if done}",
      comment: "#{Faker::Lorem.sentence if has_comment}"
    }.to_json }
  end
end
