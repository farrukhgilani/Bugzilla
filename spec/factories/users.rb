# frozen_string_literal: true
require 'faker'
FactoryBot.define do
  factory :user do
    name  {Faker::Artist.name}
    email {Faker::Internet.email}
    password {Faker::Internet.password(min_length: 10)}
    user_type { 'manager' }
  end
end
