FactoryBot.define do
  factory :user do
    fullname {Faker::Name.name}
    email {Faker::Internet.email}
    role {"guest"}
    online {"online"}
  end
end
