FactoryBot.define do
  factory :tracking_link do
    association :client, strategy: :create
    target_url { Faker::Internet.url }
  end
end
