# frozen_string_literal: true
require 'faker'
FactoryBot.define do
  factory :bug do
    title {Faker::Lorem.words(number: 4)}
    deadline { Faker::Date.between(from: '2014-09-23', to: '2020-09-25') }
    bug_type {"bug"}
    project
    # bug_status {"New"}
  end
end
