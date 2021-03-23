require 'rails_helper'

RSpec.describe '商品購入機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @order_delivery = FactoryBot.build(:order_delivery, user_id: @user.id, item_id: @item.id)
    sleep 0.5
  end
  context '正常系' do 
    it 'ログインしている出品者以外のユーザーが正しい情報を入力すると、商品の購入が出来る' do
      # ログインする
      sign_in(@user)
      # 商品詳細ページへ移動する
      visit item_path(@item)
      # 購入画面に進むボタンがあることを確認する
      expect(page).to have_content('購入画面に進む')
      # 購入画面に進むボタンを押す
      click_on('購入画面に進む')
      # 商品購入ページへ遷移したことを確認する
      expect(current_path).to eq(item_orders_path(@item))
      # 購入情報を入力する
      fill_in 'card-number', with: 4242424242424242
      fill_in 'card-exp-month', with: 2
      fill_in 'card-exp-year', with: 22
      fill_in 'card-cvc', with: 123
      fill_in 'postal-code', with: @order_delivery.zip_code
      select(Prefecture.data[@order_delivery.prefecture_id-1][:name], from: 'prefecture')
      fill_in 'city', with: @order_delivery.city
      fill_in 'addresses', with: @order_delivery.house_number
      fill_in 'building', with: @order_delivery.building_name
      fill_in 'phone-number', with: @order_delivery.phone_number
      # 購入するボタンを押すとOrderモデルのカウントが1上がることを確認する
      expect{
        click_on('購入')
        sleep 3
      }.to change { Order.count }.by(1)
      # Sold Out!!の表示があることを確認する
      expect(page).to have_content('Sold Out!!')
    end
  end
  context '異常系' do 
    it 'ログインしている出品者以外のユーザーが誤った情報を入力すると、商品の購入が出来ず商品購入ページに戻る' do
      # ログインする
      sign_in(@user)
      # 商品詳細ページへ移動する
      visit item_path(@item)
      # 購入画面に進むボタンがあることを確認する
      expect(page).to have_content('購入画面に進む')
      # 購入画面に進むボタンを押す
      click_on('購入画面に進む')
      # 商品購入ページへ遷移したことを確認する
      expect(current_path).to eq(item_orders_path(@item))
      # 購入情報を入力する(空欄)
      fill_in 'card-number', with: ''
      fill_in 'card-exp-month', with: ''
      fill_in 'card-exp-year', with: ''
      fill_in 'card-cvc', with: ''
      fill_in 'postal-code', with: ''
      select('--', from: 'prefecture')
      fill_in 'city', with: ''
      fill_in 'addresses', with: ''
      fill_in 'building', with: ''
      fill_in 'phone-number', with: ''
      # 購入するボタンを押してもOrderモデルのカウントが上がらないことを確認する
      expect{
        click_on('購入')
        sleep 3
      }.to change { Order.count }.by(0)
      # 商品購入ページへ戻ることを確認する
      expect(current_path).to eq(item_orders_path(@item))
      # エラーメッセージが表示されることを確認する
      expect(page).to have_content('クレジットカード情報を入力してください')
    end
    it 'ログインしている出品者は、商品の購入が出来ない' do
      # ログインする
      sign_in(@item.user)
      # 商品詳細ページへ移動する
      visit item_path(@item)
      # 購入画面に進むボタンがないことを確認する
      expect(page).to have_no_content('購入画面に進む')
      # 商品購入ページへ遷移しようとするとトップページにリダイレクトされることを確認する
      visit item_orders_path(@item)
      expect(current_path).to eq(root_path)
    end
    it 'ログインしていないユーザーは、商品の購入が出来ない' do
      # トップページに移動する
      visit root_path
      # 商品詳細ページへ移動する
      visit item_path(@item)
      # 購入画面に進むボタンがないことを確認する
      expect(page).to have_no_content('購入画面に進む')
      # 商品購入ページへ遷移しようとするとログインページにリダイレクトされることを確認する
      visit item_orders_path(@item)
      expect(current_path).to eq(new_user_session_path)
    end
  end
end
