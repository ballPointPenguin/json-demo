# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    transient do
      link_count { Faker::Number.within(range: 0..3) }
    end

    age { Faker::Number.within(range: 18..80) }
    city { Faker::Address.city }
    country { "USA" }
    email { Faker::Internet.email }
    gender { Faker::Gender.type }
    links { link_count.times.map { Faker::Internet.url } }
    name { Faker::Name.name }
    password { Faker::Internet.password(min_length: 8, max_length: 32) }
    password_confirmation { "#{password}" }
    state { Faker::Address.state_abbr }
  end
end
