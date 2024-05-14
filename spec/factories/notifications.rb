FactoryBot.define do
  factory :notification do
    title { Faker::Lorem.sentence }
    url { Faker::Internet.url }
  end
end
