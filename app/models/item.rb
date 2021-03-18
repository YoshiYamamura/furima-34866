class Item < ApplicationRecord
  belongs_to :user
  has_one :order
  has_one_attached :image

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :condition
  belongs_to :fee_allocation
  belongs_to :prefecture
  belongs_to :delivery_period

  with_options presence: true do
    validates :image
    validates :name
    validates :info
    validates :price, numericality: { greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 , message: "は、半角数字、¥300〜9,999,999の範囲で入力してください" }
    with_options numericality: { other_than: 1, message: "を選択してください" } do
      validates :category_id
      validates :condition_id
      validates :fee_allocation_id
      validates :prefecture_id
      validates :delivery_period_id
    end
  end
end
