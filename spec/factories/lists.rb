FactoryBot.define do
  factory :list do
    sequence(:name) { |n| "name-#{n}" }
  end
end
