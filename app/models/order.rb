class Order < ApplicationRecord
  belongs_to :user
  belongs_to :items
  has_one :delivery
end
