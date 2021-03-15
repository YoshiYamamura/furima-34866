class OrderDelivery
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :zip_code, :prefecture_id, :city, :house_number, :building_name, :phone_number, :order_id
  
  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :zip_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/ }
    validates :prefecture_id
    validates :city
    validates :house_number
    validates :phone_number, numericality: { only_integer: true }, length: { maximum: 11 }
  end

  def save
    order = Order.create(user_id: user_id, item_id: item_id)
    Delivery.create(zip_code: zip_code, prefecture_id: prefecture_id, city: city, house_number: house_number, building_name: building_name, phone_number: phone_number, order_id: order.id)
  end
end