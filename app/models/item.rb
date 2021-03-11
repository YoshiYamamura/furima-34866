class Item < ApplicationRecord
  belongs_to :user
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
    validates :price, numericality: { greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }
    with_options numericality: { other_than: 1 } do
      validates :category_id
      validates :condition_id
      validates :fee_allocation_id
      validates :prefecture_id
      validates :delivery_period_id
    end
  end
end
