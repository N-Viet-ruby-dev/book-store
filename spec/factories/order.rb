FactoryBot.define do
  factory :order do
    total_price {Faker::Number.number(digits: 3)}
    association :user
    status {"finish"}
    name {Faker::Name.name}
    email {Faker::Internet.email}
    address {Faker::Address.city}
    phone_number {"0987654321"}
    card_number {"1234567890"}
  end
end
