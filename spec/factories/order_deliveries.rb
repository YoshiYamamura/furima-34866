FactoryBot.define do
  factory :order_delivery do
    token         { 'tok_abcdefg000000000000000000000' }
    zip_code      { '123-4567' }
    prefecture_id { Faker::Number.between(from: 2, to: 48) }
    city          { '東京都千代田区' }
    house_number  { '千代田1番1号' }
    building_name { '御所' }
    phone_number  { Faker::Number.leading_zero_number(digits: 11) }
    user_id       { Faker::Number.non_zero_digit }
    item_id       { Faker::Number.non_zero_digit }
  end
end
