require 'rails_helper'

RSpec.describe OrderDelivery, type: :model do
  before do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item)
    @order_delivery = FactoryBot.build(:order_delivery, user_id: user.id, item_id: item.id)
    sleep 0.5
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
        expect(@order_delivery.errors.full_messages).to include('クレジットカード情報を入力してください')
      end
      it 'zip_codeが空では購入できない' do
        @order_delivery.zip_code = ''
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('郵便番号を入力してください')
      end
      it 'zip_codeがハイフンなしでは購入できない' do
        @order_delivery.zip_code = '1234567'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('郵便番号は、半角数字3桁と4桁の間に -（ハイフン）を付けてください')
      end
      it 'zip_codeが半角数字以外では購入できない' do
        @order_delivery.zip_code = '１２３ー４５６７'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('郵便番号は、半角数字3桁と4桁の間に -（ハイフン）を付けてください')
      end
      it 'prefecture_idが1(未選択)では購入できない' do
        @order_delivery.prefecture_id = 1
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('都道府県を選択してください')
      end
      it 'cityが空では購入できない' do
        @order_delivery.city = ''
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('市区町村を入力してください')
      end
      it 'house_numberが空では購入できない' do
        @order_delivery.house_number = ''
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('番地を入力してください')
      end
      it 'phone_numberが空では購入できない' do
        @order_delivery.phone_number = ''
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('電話番号を入力してください')
      end
      it 'phone_numberが12桁以上では購入できない' do
        @order_delivery.phone_number = '123456789012'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('電話番号は11文字以内で入力してください')
      end
      it 'phone_numberがハイフンありでは購入できない' do
        @order_delivery.phone_number = '090-1234-5678'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('電話番号は、半角数字で -（ハイフン）を付けずに入力してください')
      end
      it 'phone_numberが全角数字では購入できない' do
        @order_delivery.phone_number = '０９０１２３４５６７８'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('電話番号は、半角数字で -（ハイフン）を付けずに入力してください')
      end
      it 'phone_numberが英数混合では購入できない' do
        @order_delivery.phone_number = '123456789ab'
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('電話番号は、半角数字で -（ハイフン）を付けずに入力してください')
      end
      it 'user_idが紐付いていないと購入できない' do
        @order_delivery.user_id = nil
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('Userを入力してください')
      end
      it 'item_idが紐付いていないと購入できない' do
        @order_delivery.item_id = nil
        @order_delivery.valid?
        expect(@order_delivery.errors.full_messages).to include('Itemを入力してください')
      end
    end
  end
end
