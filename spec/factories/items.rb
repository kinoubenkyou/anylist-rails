FactoryBot.define do
  factory :item do
    list
    sequence(:value) { |n| "value-#{n}" }
    sequence(:description) { |n| "description-#{n}" }
  end
end
