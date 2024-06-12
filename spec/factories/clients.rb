FactoryBot.define do
  factory :client do
    name { Faker::Company.name }
    store_url { Faker::Internet.url }

    initialize_with { Client.find_by(store_url: attributes[:store_url]) || new(attributes) }
  end
end
