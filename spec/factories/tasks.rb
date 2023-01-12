# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: Task::Infrastructure::ActiveRecordModels::Task do
    name { Faker::Name.unique.name }
    description { Faker::Name.unique.name }
    due_at { 1.day.from_now }
    completed { false }
  end
end
