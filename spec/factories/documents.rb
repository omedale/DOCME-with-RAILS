FactoryGirl.define do
  factory :document do
    title { Faker::StarWars.character }
    owner { Faker::Name.name }
    access { Faker::Lorem.word }
    content { Faker::Lorem.sentences }
    user_id nil
  end
end
