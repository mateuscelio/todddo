# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { 'MyString' }
    description { 'MyString' }
    due_at { '2022-09-29 12:54:59 UTC' }
  end
end
