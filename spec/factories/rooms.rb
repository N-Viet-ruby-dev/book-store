FactoryBot.define do
  sequence :name do |n|
    "Room Guest #{n}"
  end

  factory :room do
    name { generate :name }
    status { :opening }
    association :guest, factory: :guest_user
  end
end
