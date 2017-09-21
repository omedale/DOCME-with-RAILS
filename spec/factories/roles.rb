FactoryGirl.define do
  factory :role do
    role        { Faker::Lorem.word  }
    description { Faker::Lorem.paragraph }
  end
end