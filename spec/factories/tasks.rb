# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { Faker::Name.unique.name }
    description { Faker::Name.unique.name }
    due_at { 1.day.from_now }
  end
end
