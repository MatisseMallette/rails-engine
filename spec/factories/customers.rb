# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    invoice_item { 'MyString' }
    invoice { 'MyString' }
    item { 'MyString' }
    transaction { 'MyString' }
  end
end
