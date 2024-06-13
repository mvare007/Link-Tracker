FactoryBot.define do
  factory :tracking_link do
    association :client, strategy: :create
  end
end
