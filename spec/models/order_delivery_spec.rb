require 'rails_helper'

RSpec.describe OrderDelivery, type: :model do
  before do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item)
    @order_delivery = FactoryBot.build(:order_delivery, user_id: user.id, item_id: item.id)
    sleep 0.5 #read_timeoutエラーの回避
  end

  describe '商品購入機能' do
    context '正常系' do
      it 'token, zip_code, prefecture_id, city, house_number, building_name, phone_numberが存在すれば購入できる' do
        expect(@order_delivery).to be_valid
      end
      it 'building_nameは空でも購入できる' do
        @order_delivery.building_name = ''
        expect(@order_delivery).to be_valid
      end
    end

    context '異常系' do
      it 'tokenが空では購入できない' do
        @order_delivery.token = nil
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include("Token can't be blank")
      end
      it 'zip_codeが空では購入できない' do
        @order_delivery.zip_code = ''
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('Zip code is invalid')
      end
      it 'zip_codeがハイフンなしでは購入できない' do
        @order_delivery.zip_code = '1234567'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('Zip code is invalid')
      end
      it 'zip_codeが半角数字以外では購入できない' do
        @order_delivery.zip_code = '１２３ー４５６７'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('Zip code is invalid')
      end
      it 'prefecture_idが1(未選択)では購入できない' do
        @order_delivery.prefecture_id = 1
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('Prefecture must be other than 1')
      end
      it 'cityが空では購入できない' do
        @order_delivery.city = ''
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include("City can't be blank")
      end
      it 'house_numberが空では購入できない' do
        @order_delivery.house_number = ''
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include("House number can't be blank")
      end
      it 'phone_numberが空では購入できない' do
        @order_delivery.phone_number = ''
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include("Phone number can't be blank")
      end
      it 'phone_numberが12桁以上では購入できない' do
        @order_delivery.phone_number = '123456789012'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('Phone number is too long (maximum is 11 characters)')
      end
      it 'phone_numberがハイフンありでは購入できない' do
        @order_delivery.phone_number = '090-1234-5678'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('Phone number is not a number')
      end
      it 'phone_numberが全角数字では購入できない' do
        @order_delivery.phone_number = '０９０１２３４５６７８'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('Phone number is not a number')
      end
      it 'phone_numberが英数混合では購入できない' do
        @order_delivery.phone_number = '123456789ab'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('Phone number is not a number')
      end
      it 'user_idが紐付いていないと購入できない' do
        @order_delivery.user_id = nil
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include("User can't be blank")
      end
      it 'item_idが紐付いていないと購入できない' do
        @order_delivery.item_id = nil
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include("Item can't be blank")
      end
    end
  end
end
