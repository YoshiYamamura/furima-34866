FactoryBot.define do
  factory :user do
    nickname              { Faker::Internet.username }
    family_name           { '山田' }
    first_name            { '太郎' }
    family_name_kana      { 'ヤマダ' }
    first_name_kana       { 'タロウ' }
    birth                 { Faker::Date.between(from: 80.years.ago, to: Date.today) }
    email                 { Faker::Internet.email }
    password              { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
  end
end
