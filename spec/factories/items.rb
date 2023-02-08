# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { Faker::Games::Dota.item }
    description { "#{Faker::Games::Dota.item} Description" }
    unit_price { Faker::Number.between(from: 0, to: 100) }
  end
end
