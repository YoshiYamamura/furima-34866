require 'rails_helper'

RSpec.describe '商品出品機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.build(:item)
  end
  context '正常系' do 
    it 'ログインユーザーが正しい情報を入力すると、商品の出品が出来る' do
      # ログインする
      sign_in(@user)
      # 商品出品ボタンがあることを確認する
      expect(page).to have_content('出品する')
      # 商品出品ページへ移動する
      visit new_item_path
      # 商品情報を入力する
      #attach_file('item[image]', url_for(@item.image)) #認証付URLにリダイレクトされ画像取得できない
      attach_file('item[image]', 'public/images/test_image.jpeg')
      fill_in 'item-name', with: @item.name
      fill_in 'item-info', with: @item.info
      select(@item.category.name, from: 'item-category')
      select(@item.condition.name, from: 'item-sales-status')
      select(@item.fee_allocation.name, from: 'item-shipping-fee-status')
      select(@item.prefecture.name, from: 'item-prefecture')
      select(@item.delivery_period.name, from: 'item-scheduled-delivery')
      fill_in 'item-price', with: @item.price
      # 出品するボタンを押すとItemモデルのカウントが1上がることを確認する
      expect{
        click_on('出品する')
      }.to change { Item.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # トップページに出品した商品の商品名、販売価格、配送料の負担、画像があることを確認する
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.price)
      expect(page).to have_content(@item.fee_allocation.name)
      expect(page).to have_selector('.item-img')
    end
  end
  context '異常系' do 
    it 'ログインユーザーが誤った情報を入力すると、商品出品が出来ず商品出品ページに戻る' do
      # ログインする
      sign_in(@user)
      # 商品出品ボタンがあることを確認する
      expect(page).to have_content('出品する')
      # 商品出品ページへ移動する
      visit new_item_path
      # 商品情報を入力する（空欄）
      fill_in 'item-name', with: ''
      fill_in 'item-info', with: ''
      select('--', from: 'item-category')
      select('--', from: 'item-sales-status')
      select('--', from: 'item-shipping-fee-status')
      select('--', from: 'item-prefecture')
      select('--', from: 'item-scheduled-delivery')
      fill_in 'item-price', with: ''
      # 出品するボタンを押してもItemモデルのカウントは上がらないことを確認する
      expect{
        click_on('出品する')
      }.to change { Item.count }.by(0)
      # 商品出品ページへ戻されることを確認する
      expect(current_path).to eq('/items')
      # エラーメッセージが表示されることを確認する
      expect(page).to have_content('画像を入力してください')
    end
    it 'ログインしていないユーザーは、商品出品ページに遷移出来ずログインページにリダイレクトされる' do
      # トップページに移動する
      visit root_path
      # 商品出品ボタンを押す
      click_on('出品する')
      # ログインページにリダイレクトされることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end  
end
