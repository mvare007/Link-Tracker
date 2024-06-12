FactoryBot.define do
  factory :visit do
    association :tracking_link, strategy: :create
    ip_address { Faker::Internet.ip_v4_address }
    user_agent { Faker::Internet.user_agent }
  end
end
