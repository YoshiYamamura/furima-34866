# テーブル設計

## usersテーブル
|Column          |Type  |Options                  |
|----------------|------|-------------------------|
|nickname        |string|null: false              |
|family_name     |string|null: false              |
|first_name      |string|null: false              |
|family_name_kana|string|null: false              |
|first_name_kana |string|null: false              |
|birth_year      |string|null: false              |
|birth_month     |string|null: false              |
|birth_day       |string|null: false              |
|password        |string|null: false              |
|email           |string|null: false, unique: true|

### Association
- has_many :items
- has_many :orders

## itemsテーブル
|Column        |Type      |Options                       |
|--------------|----------|------------------------------|
|item_name     |string    |null: false                   |
|info          |text      |null: false                   |
|price         |integer   |null: false                   |
|category      |integer   |null: false                   |
|condition     |integer   |null: false                   |
|fee_allocation|integer   |null: false                   |
|delivery_from |integer   |null: false                   |
|delivery_days |integer   |null: false                   |
|user_id       |references|null: false, foreign_key: true|

### Association
- belongs_to :user
- has_one    :order

## ordersテーブル
|Column |Type      |Options                       |
|-------|----------|------------------------------|
|user_id|references|null: false, foreign_key: true|
|item_id|references|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :item
- has_one    :delivery

## deliveriesテーブル
|Column       |Type      |Options                       |
|-------------|----------|------------------------------|
|zip_code     |integer   |null: false                   |
|prefecture   |string    |null: false                   |
|city         |string    |null: false                   |
|house_number |string    |null: false                   |
|building_name|string    |                              |
|phone_number |string    |null: false                   |
|order_id     |references|null: false, foreign_key: true|

### Association
- belongs_to :order