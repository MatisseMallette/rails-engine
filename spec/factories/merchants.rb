FactoryBot.define do
  factory :merchant do
    name { Faker::Book.author }
  end
end
