class CreateDeliveries < ActiveRecord::Migration[6.0]
  def change
    create_table :deliveries do |t|
      t.string     :zip_code,         null: false
      t.integer    :prefecture_id,    null: false
      t.string     :city,             null: false
      t.string     :house_number,     null: false
      t.string     :building_name
      t.string     :phone_number,     null: false
      t.references :order,            foreign_key: true
      t.timestamps
    end
  end
end
