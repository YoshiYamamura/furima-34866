require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品出品機能' do
    context '正常系' do
      it 'name, info, price, category_id, condition_id, fee_allocation_id, prefecture_id, delivery_period_id, imageが存在すれば登録できる' do
        expect(@item).to be_valid
      end
    end
    context '異常系' do
      it 'nameが空では出品できない' do
        @item.name = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('商品名を入力してください')
      end
      it 'infoが空では出品できない' do
        @item.info = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('商品の説明を入力してください')
      end
      it 'priceが空では出品できない' do
        @item.price = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格を入力してください')
      end
      it 'priceが300円未満では出品できない' do
        @item.price = 299
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は、半角数字、¥300〜9,999,999の範囲で入力してください')
      end
      it 'priceが9,999,999円超では出品できない' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は、半角数字、¥300〜9,999,999の範囲で入力してください')
      end
      it 'priceが全角数字では出品できない' do
        @item.price = '１００００'
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は、半角数字、¥300〜9,999,999の範囲で入力してください')
      end
      it 'priceが漢数字では出品できない' do
        @item.price = '壱万円'
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は、半角数字、¥300〜9,999,999の範囲で入力してください')
      end
      it 'priceが英数混合では出品できない' do
        @item.price = '1manYen'
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は、半角数字、¥300〜9,999,999の範囲で入力してください')
      end
      it 'priceが半角英字では出品できない' do
        @item.price = 'ichimanYen'
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は、半角数字、¥300〜9,999,999の範囲で入力してください')
      end
      it 'category_idが1(未選択)では出品できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('カテゴリーを選択してください')
      end
      it 'condition_idが1(未選択)では出品できない' do
        @item.condition_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('商品の状態を選択してください')
      end
      it 'fee_allocation_idが1(未選択)では出品できない' do
        @item.fee_allocation_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('配送料の負担を選択してください')
      end
      it 'prefecture_idが1(未選択)では出品できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('発送元の地域を選択してください')
      end
      it 'delivery_period_idが1(未選択)では出品できない' do
        @item.delivery_period_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('発送までの日数を選択してください')
      end
      it 'imageが空では出品できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('画像を入力してください')
      end
      it 'userが紐付いていないと出品できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('Userを入力してください')
      end
    end
  end
end
