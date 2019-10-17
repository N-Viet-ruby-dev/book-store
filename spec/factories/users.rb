FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :guest_user, class: :User do
    fullname { "User Test" }
    email { generate :email }
    password { "asdfasdf" }
    password_confirmation { "asdfasdf" }
    role { :guest }
    online { :offline }
  end

  factory :admin_user, class: :User do
    fullname { "Admin User" }
    email { generate :email }
    password { "asdfasdf" }
    password_confirmation { "asdfasdf" }
    role { :admin }
    online { :offline }
  end
end
