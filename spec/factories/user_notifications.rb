FactoryBot.define do
  factory :user_notification do
    read { false }
    notification { nil }
    user { nil }
  end
end
