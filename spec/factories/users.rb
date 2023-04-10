# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User::Infrastructure::ActiveRecordModels::User do
    name { Faker::Name.unique.name }
    email { Faker::Internet.email }
    password { 'password' }
  end
end
