# frozen_string_literal: true
require 'faker'
FactoryBot.define do
  factory :project do
    name {Faker::Name.name }
    description {Faker::Lorem.sentence(word_count: 20)}

  end
end
