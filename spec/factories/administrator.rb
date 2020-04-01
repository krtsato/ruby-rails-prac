# frozen_string_literal: true

FactoryBot.define do
  factory :administrator do
    sequence(:email) {|n| "admin#{n}@example.com"}
    password {'password'}
    suspended {false}
  end
end
