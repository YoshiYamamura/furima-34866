# テーブル設計

## usersテーブル
|Column            |Type  |Options                  |
|------------------|------|-------------------------|
|nickname          |string|null: false              |
|family_name       |string|null: false              |
|first_name        |string|null: false              |
|family_name_kana  |string|null: false              |
|first_name_kana   |string|null: false              |
|birth             |date  |null: false              |
|encrypted_password|string|null: false              |
|email             |string|null: false, unique: true|

### Association
- has_many :items
- has_many :orders

## itemsテーブル
|Column           |Type      |Options                       |
|-----------------|----------|------------------------------|
|name             |string    |null: false                   |
|info             |text      |null: false                   |
|price            |integer   |null: false                   |
|category_id      |integer   |null: false                   |
|condition_id     |integer   |null: false                   |
|fee_allocation_id|integer   |null: false                   |
|prefecture_id    |integer   |null: false                   |
|delivery_days_id |integer   |null: false                   |
|user             |references|null: false, foreign_key: true|

### Association
- belongs_to :user
- has_one    :order

## ordersテーブル
|Column |Type      |Options                       |
|-------|----------|------------------------------|
|user   |references|null: false, foreign_key: true|
|item   |references|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :item
- has_one    :delivery

## deliveriesテーブル
|Column       |Type      |Options                       |
|-------------|----------|------------------------------|
|zip_code     |string    |null: false                   |
|prefecture_id|integer   |null: false                   |
|city         |string    |null: false                   |
|house_number |string    |null: false                   |
|building_name|string    |                              |
|phone_number |string    |null: false                   |
|order        |references|null: false, foreign_key: true|

### Association
- belongs_to :order