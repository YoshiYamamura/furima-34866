FactoryBot.define do
  factory :item do
    name              { Faker::Name.name }
    info              { Faker::Lorem.sentence }
    price             { Faker::Number.between(from: 300, to: 9_999_999) }
    category_id       { Faker::Number.between(from: 2, to: 11) }
    condition_id      { Faker::Number.between(from: 2, to: 7) }
    fee_allocation_id { Faker::Number.between(from: 2, to: 3) }
    prefecture_id     { Faker::Number.between(from: 2, to: 48) }
    delivery_days_id  { Faker::Number.between(from: 2, to: 4) }

    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.jpeg'), filename: 'test_image.jpeg')
    end
  end
end
